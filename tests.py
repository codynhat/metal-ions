import unittest
from blast_pipeline import get_upstream_from_strand
from Bio.Seq import Seq

class UpStreamTest(unittest.TestCase):

    def testPositiveStrand(self):
        s = Seq("AGGTAGAGTTAGAGAAAG")
        result = get_upstream_from_strand(s, 1, 5, 7, 5)
        expected = Seq("AGGTA")
        self.assertEqual(result, expected)

    def testPositiveStrand1(self):
        s = Seq("AGGTAGAGTTAGAGAAAG")
        result = get_upstream_from_strand(s, 1, 6, 7, 5)
        expected = Seq("GGTAG")
        self.assertEqual(result, expected)

    def testNegativeStrand(self):
        s = Seq("AGGTAGAGTTAGAGAAAG")
        result = get_upstream_from_strand(s, -1, 5, 7, 5)
        expected = Seq("TCTAA")
        self.assertEqual(result, expected)

    def testNegativeStrand1(self):
        s = Seq("AGGTAGAGTTAGAGAAAG")
        result = get_upstream_from_strand(s, -1, 5, 9, 3)
        expected = Seq("TCT")
        self.assertEqual(result, expected)

