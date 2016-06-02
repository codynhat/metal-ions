from Bio import SeqIO
from Bio.Align.Applications import ClustalOmegaCommandline

def cluster_BLAST_output(fasta_in, cluster_size):
    """
        Cluster sequences in a multi-FASTA file (fasta_in) based on similarity.

        Specify preferred cluster size (cluster_size).

        Returns a multi-FASTA file for each cluster.

    """
    
    # Pass inputs to ClustalOmega
    accession = ".".join(fasta_in.split(".")[0:-1])
    cluster_out = "{}.{}".format(accession, "aux")
    cline = ClustalOmegaCommandline(infile=fasta_in, clusteringout=cluster_out, clustersize=cluster_size)
    cline()

    # Check that fasta_in has sufficient number of sequences for clustering
    try:
        clust_file = open(cluster_out, "r")
    except FileNotFoundError:
        print("The FASTA input has too few sequences for the given cluster size.")
        return

    # Read cluster_out file, append accessions to cluster dictionary
    clusters = {}
    for line in clust_file.readlines():
        line = line.split()
        cluster = int(line[1][0:-1])
        seq = line[8]
        clusters.setdefault(cluster, []).append(seq)
    clust_file.close()

    # Write cluster FASTA files
    for i in range(0, len(clusters)):
        input_handle = open(fasta_in, "rU")
        cluster_out = "{}_{}_{}.{}".format(accession, "cluster", i, "fasta")
        output_handle = open(cluster_out, "w")
        SeqIO.write((seq for seq in SeqIO.parse(input_handle,'fasta') if seq.id in clusters[i]), output_handle, "fasta")
        output_handle.close()

if __name__ == '__main__':
    cluster_BLAST_output("ABC93653.1.fasta", 23)
