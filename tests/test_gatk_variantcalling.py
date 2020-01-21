# Copyright (c) 2018 Leiden University Medical Center
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

import os
import subprocess
import tempfile
from pathlib import Path

import pytest

TEST_DATA = Path(Path(__file__).parent, "data")


def create_sdf(sequence_path: Path) -> Path:
    # We need a not yet existing directory. Hence mkstemp. (Even though this
    # is unsafe as another tempfile process may claim the directory in theory.)
    output_sdf = tempfile.mkstemp()
    args = ["rtg", "format", "-o", output_sdf, str(sequence_path)]
    subprocess.run(args, check=True)
    return Path(output_sdf)


@pytest.mark.workflow("two_sample_gender_aware")
def test_variants_gender_aware(workflow_dir: Path):
    baseline_vcf_file = Path(TEST_DATA, "gender-aware", "expected.vcf.gz")
    calls_vcf_file = Path(workflow_dir, "test-output", "multisample.vcf.gz")
    reference_fasta = Path(TEST_DATA, "gender-aware", "reference.fasta")
    sdf_path = create_sdf(reference_fasta)
    output_dir = Path(tempfile.mkdtemp())
    args = ["rtg", "vcfeval",
            "-b", str(baseline_vcf_file),
            "-c", str(calls_vcf_file),
            "-t", str(sdf_path),
            "-o", str(output_dir),
            "--sample", "male"]
    subprocess.run(args, check=True)
    print(output_dir)
