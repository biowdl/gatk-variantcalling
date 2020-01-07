import argparse

from Bio.SeqIO.FastaIO import FastaIterator
from Bio import SeqRecord


def argument_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Extract a region from the first record of a fasta file.")
    parser.add_argument("filename", type=str)
    parser.add_argument("region_start", type=int, help="regions are 1 based")
    parser.add_argument("region_end", type=int)
    return parser


if __name__ == "__main__":
    args = argument_parser().parse_args()
    with open(args.filename, mode="rt") as fasta_h:
        record = next(FastaIterator(fasta_h))  # type: SeqRecord
        region_of_interest = record[args.region_start - 1: args.region_end]
        print(region_of_interest.format("fasta"))
