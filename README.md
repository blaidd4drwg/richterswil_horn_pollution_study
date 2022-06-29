# Richterswil pollution study repo

## Motivation
This repository provides code and data that are necessary to reproduce results found in the study "Tracking the legacy of early industrial activity in sediments of Lake Zurich, Switzerland: Using a novel multi-proxy approach to find the source of extensive metal contamination", accepted on 31 May 2022 by [Environmental Science and Pollution Research (ESPR)](https://www.springer.com/journal/11356)) with the DOI:

[![DOI:10.1007/s11356-022-21288-6](https://zenodo.org/badge/DOI/10.1007/s11356-022-21288-6.svg)](https://doi.org/10.1007/s11356-022-21288-6)

Additionally, a full dataset including linescans/photographs of all sediment cores can be found at Eawag's ERIC Public Archive:

[![DOI:10.25678/0005Y5](https://zenodo.org/badge/DOI/10.25678/0005Y5.svg)](https://doi.org/10.25678/0005Y5)

The documented analyses (rendered Rmarkdown) can be found [here](https://blaidd4drwg.github.io/richterswil_horn_pollution_study).

## General structure of the repository
The general structure of the project repository is as shown below (only directories shown, `renv` subfolders hidden. The root directory contains the following files:

* `README.md` This very readme file.
* `contased_article_repo.Rproj` RStudio project preferences.
* `renv.lock` lock file for the _renv_ R package that records the version of R and R packages used in the project.
* `richterswil_pollution_analyses.Rmd` The [documented analyses](./richterswil_pollution_analyses.Rmd) of this project.



```
.
├── R
├── data
│   ├── processed
│   │   └── linescans
│   └── raw
│       ├── coordinates
│       ├── hg_afs
│       ├── hg_isotopes
│       ├── icp_oes
│       ├── radiodating
│       ├── tc_tic
│       └── xrf_cs
├── docs
├── output
└── renv
```

### `R` folder
Contains helper functions necessary for the analyses. In this case only `avaatech_xrf_corescanner.R` which provides a function to read and parse files produced by an Avaatech XRF Corescanner and the WinAXIL Batch software.

### `data` folder
#### `processed` subfolder
Contains processed linescans/core photographs of sediment cores necessary to produce composite plots. The files were processed as follows:

* `AW-13-16_app4.8_50cm.jpg` was cropped to contain the top of the core down to 50 cm and converted to (lossy) JPEG.
* `ZH-16-11_ap5.6_50cm.jpg` was cropped to contain the top of the core down to 50 cm and converted to (lossy) JPEG.

#### `raw` subfolder
Contains data that was used as is without data transformation, i.e. directly in the format that was provided with the measurements. In some case, information was added, to facilitate further processing:

* `coordinates` contains the coordinates of all sediment cores used in this project. The file `20161221_zh16_coords.csv` contains a compilation of original GPS data as recorded with the Fugawi Explorer programme. The coordinates are given in CH1903 and WGS84 coordinates.
* `hg_afs` contains Hg concentrations measured by CV-Hg-AFS from two dates (22 March 2017 and 18 May 2017) for measurements of a total digestion of samples from ZH-16-10, and for measurements of sequentials extractions and total digestion of sample from AW-13-16, ZH-16-10 and ZH-16-11 respectively. These files were amended with additional columns containing metadata (e.g. extraction, run, digestion). Concentrations in the raw files are given in ng/ml (ppb) and refer to the diluted sample solutions.
* `hg_isotope` contains the Hg isotope measurements made in Vienna on a Nu instruments MC-ICP-MS (`201705_hgiso_richterswil.csv`) in May 2017. This file was not modified. Values are given as ratios or voltages.
* `icp_oes` contains the ICP-OES measurements made at Eawag (`20170310_icp_oes_richterswil.csv`) on 10 March 2017 from samples of two digestion runs. The file contains additional columns with metadata regarding digestion run, sample name, sediment depth etc. The files `icp_oes_digestion1_weights_richterswil.txt` and `icp_oes_digestion2_weights_richterswil.txt` contain the weights of the sediment samples used for the aqua digestions used in the first and second digestion run respectively. The values given in the icp-oes files are given as counts from optical emission.
* `radiodating` contains the files `gammadating_AW1316_activities_richterswil.csv`, `gammadating_AW1316_name_lookup_richterswil.csv`, `gammadating_ZH1611_activities_richterswil.csv`, `gammadating_ZH1611_name_lookup_richterswil.csv`, `pu_dating_AW1316_richterswil.csv` which contain measured activity in [Bq/kg] and the respective uncertainty given as 2σ (1σ for Pu dating) on one hand and the corresponding sample name/depth lookup tables on the other hand. Tables were simplified but the content was not altered.
* `tc_tic` contains the original TIC (total inorganic carbon, in % w/w Carbonate) measurements (`20170531_tic_richterswil.txt`) as exported from the Shimadzu SSM 5000A analyser, while the TC (total carbon, in % w/w) measurements were printed by a LECO CHNS 932 automatic analyser and digitalised manually afterwards (TC FILENAME).
* `xrf_cs` contains the Avaatech XRF-Corescanner data (XRF counts/fitted areas) as produced by WinAXIL Batch and converted to csv-files. The following modifications were done in Microsoft Excel:
  * Ca,K,Ba columns were dropped from 10 kVb sheets (duplicates), because higher Chi-Square mean values than at 30 kV.
  * Dashed "-" were replaced with "_"

### `docs` folder
The `docs` folder contains the compiled ("knitted") HTML report `index.html` generated by Rmarkdown. This folder and the contained HTML file are used to create the Github Pages site showing the results of the analyses.

### `output` folder
The `output` folder contains figures and tables produced during the analyses for use with the manuscript (or further editing).

### `renv` folder
The `renv` folder contains different dynamically created files and directories including (links to and/or files of) used packages with their respective version recorded. It is possible to use the same R version and package versions using `renv` (as long as the necessary R version is installed on the target system).

## Missing data
The following data are not included in the repository:

* Linescan/core photograph originals: The linescans for this project are around 50 MB per file (TIFF) and are too large to be included in a git repository (and the use of git Large File Storage LFS has some drawbacks, such as that LFS files cannot be included in github Pages. However, since the complete linescans could be relevant for further research, they are included as an additional resource in the data repository.
* Data from the Geotek Multisensory corelogger (MSCL) were not included, as they were recorded but not used for this study.
* Thermo-desorption data was only available as figures and not used for this study, thus not included.
* Adobe Illustrator files that were used to produce some of the composite figures are not included.
* The QGIS project (qgz) including the necessary Geodatabases to produce the maps is not included.
