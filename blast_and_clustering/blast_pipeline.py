from Bio.Blast.Applications import NcbitblastnCommandline
from Bio import SearchIO
from Bio import Entrez, SeqIO
import os
import subprocess
import sys
from multiprocessing import Process
from clustering import cluster_BLAST_output as cluster

Entrez.email = "chatfiel@uoregon.edu"

def blast_search(filename, blast_temp_path):
    '''
        Perform a blast search, using a file as input. Either FASTA or accession number

        Return results as list of accession numbers and locations
    '''

    filepath = "%s/%s.xml" % (blast_temp_path, filename)
    if not os.path.exists(filepath):
        with open('%s/%s' % (blast_temp_path, filename), 'w') as f:
            f.write(filename)
        search_cmd = NcbitblastnCommandline(query='%s/%s' % (blast_temp_path, filename),  db="/research/sequences/GenBank/blast/db/refseq_genomic", outfmt=5, out=filepath)
        subprocess.call(str(search_cmd), shell=True)

    result = SearchIO.read(filepath, 'blast-xml')

    # Filter e-value
    hsps = filter(lambda hit: hit.evalue < 1e-10, result.hsps)

    # Filter length
    hsps = filter(lambda hit: hit.aln_span > 209, hsps)

    # Filter identity
    iden_cutoff = 0.2
    hsps = filter(lambda hit: float(hit.ident_num)/float(result.seq_len) > iden_cutoff, hsps)

    return [(hit.hit_id.split('|')[-2], hit.hit_start, hit.hit_end) for hit in hsps]

def get_upstream_from_strand(record, strand, start, end, length):
    """
        start : start of matched sequence
        end : end of matched sequence
    """
    if strand > 0:
        return record[start-length:start]
    else:
        return record[end+1:end+1+length].reverse_complement()

def get_upstream_sequence(accession_num, start, end):
    '''
        Use Entrez to get 500bp upstream from designated locations

        Return SeqRecord
    '''

    search_result = Entrez.efetch(db="nucleotide", id=accession_num, rettype="gb", seq_start=start-500, seq_stop=end+500)
    record = SeqIO.read(search_result, "genbank")

    cds = None
    try:
        cds = filter(lambda feature: feature.location.start.position == 501 and feature.type == 'CDS', record.features)
        if len(cds) == 0:
           return None
        cds = cds[0]
    except StopIteration:
        return None

    strand = cds.strand
    return get_upstream_from_strand(record, strand, 501, 501+(end-start), 500)

def write_sequences(sequences, filename):
    '''
        Write sequences to file (FASTA)
    '''
    output_handle = open(filename, "w")
    SeqIO.write(sequences, output_handle, "fasta")
    output_handle.close()

def run_pipeline(line, blast_temp_path, outdir, cluster_size):
    '''
        Run pipeline for accession number
    '''

    # Perform blast search
    print("%s - START" % line)
    blast_results = blast_search(line, blast_temp_path)
    print("%s - found %d results after filter" % (line, len(blast_results)))

    # Get upstream sequences
    print("%s - getting upstream sequences..." % line)
    upstreams = []
    c = 1
    num_results = len(blast_results)
    for result in blast_results:
        upstream = get_upstream_sequence(result[0], result[1], result[2])
        if upstream:
	    print("%s - upstream %d/%d found" % (line, c, num_results))
            upstreams.append(upstream)
        c += 1
    print("%s - found %d upstream sequences" % (line, len(upstreams)))

    # Write to FASTA line
    print("%s - writing FASTA file" % line)
    outpath = "%s/%s" % (outdir, line)
    if not os.path.exists(outpath):
        os.makedirs(outpath)

    fasta_path = "%s/%s.fasta" % (outpath, line)
    write_sequences(upstreams, fasta_path)

    # clustering
    print("%s - Starting Clustering" % line)
    cluster(fasta_path, cluster_size)
    print("%s - Clustering Finished" % line)

def main():
    blast_temp_path = sys.argv[1] if len(sys.argv) > 1 else './blast_results'
    outdir = sys.argv[2] if len(sys.argv) > 2 else './pipeline_results'
    cluster_size = int(sys.argv[3]) if len(sys.argv) > 3 else 23

    processes = []
    for line in sys.stdin:
        line = line.replace('\n', '')
        p = Process(target=run_pipeline, args=(line,blast_temp_path,outdir,cluster_size,))
        p.start()
        processes.append(p)
    for p in processes:
        p.join()


if __name__ == '__main__':
    main()
