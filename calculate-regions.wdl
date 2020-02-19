version 1.0

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
import "tasks/bedtools.wdl" as bedtools

workflow CalculateAutosomalRegions {
    input {
        File referenceFastaFai
        File XNonParRegions
        File YNonParRegions
        File? regions
        Map[String, String] dockerImages = {
              "bedtools": "quay.io/biocontainers/bedtools:2.23.0--hdbcaa40_3"
        }
    }
    call bedtools.MergeBedFiles as mergeBeds {
        input:
            bedFiles = [XNonParRegions, YNonParRegions],
            dockerImage = dockerImages["bedtools"]
    }
    # We define the 'normal' regions by creating a regions file that covers
    # everything except the XNonParRegions and the YNonParRegions.
    call bedtools.Complement as inverseBed {
        input:
            inputBed = mergeBeds.mergedBed,
            faidx = referenceFastaFai,
            outputBed = "autosomal_regions.bed",
            dockerImage = dockerImages["bedtools"]
    }

    if (defined(regions)) {
        call bedtools.Intersect as intersectAutosomalRegions {
            input:
                regionsA = inverseBed.complementBed,
                regionsB = select_first([regions]),
                faidx = referenceFastaFai,
                outputBed = "intersected_autosomal_regions.bed",
                dockerImage = dockerImages["bedtools"]
        }

        call bedtools.Intersect as intersectX {
            input:
                regionsA = XNonParRegions,
                regionsB = select_first([regions]),
                faidx = referenceFastaFai,
                outputBed = "intersected_x_non_par_regions.bed",
                dockerImage = dockerImages["bedtools"]
        }

        call bedtools.Intersect as intersectY {
            input:
                regionsA = YNonParRegions,
                regionsB = select_first([regions]),
                faidx = referenceFastaFai,
                outputBed = "intersected_y_non_par_regions.bed",
                dockerImage = dockerImages["bedtools"]
        }
    }

    output {
        File Xregions = select_first([intersectX.intersectedBed, XNonParRegions])
        File Yregions = select_first([intersectY.intersectedBed, YNonParRegions])
        File autosomalRegions = select_first([intersectAutosomalRegions.intersectedBed, inverseBed.complementBed])
    }
}