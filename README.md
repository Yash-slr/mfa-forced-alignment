Assignment: Forced Alignment using Montreal Forced Aligner (MFA)

This repository contains the full pipeline and outputs for a forced alignment task, as per the assignment requirements.
The goal was to align a provided dataset of 6 `.wav` audio files with their corresponding `.txt` transcripts using the 
Montreal Forced Aligner (MFA).

This project also includes extra credit work:
1.Custom Dictionary: A custom dictionary was trained using a G2P model to handle out-of-vocabulary (OOV) words.
2.Multiple Models: Alignments were generated using two different English acoustic models (`english_us_arpa` and `english_mfa`)
for comparison.
3.Automation: The full pipeline (G2P and both alignments) was automated using a Windows batch script (`run_pipeline.bat`).

1.) Installation

This pipeline was run on Windows 11 and requires the Anaconda package manager.

1.Install Anaconda/Miniconda for the operating system.
2.Open the Anaconda Prompt and create a new Conda environment for MFA:
    ```bash
    conda create --name mfa python=3.10

3.Activate the environment:
    ```bash
    conda activate mfa
  
4.Install MFA: This command installs MFA and all dependencies (like Kaldi and FFmpeg):
    ```bash
    conda install -c conda-forge montreal-forced-aligner
   
5.(Windows-Specific Fix) If you encounter a `RootDirectoryError`, you must create a temp folder and set
the `MFA_ROOT_DIR` environment variable each time you open a new prompt:
    ```bash
    mkdir C:\mfa_temp
    set MFA_ROOT_DIR=C:\mfa_temp

2.) Data Preparation

1.All 6 `.wav` files and 6 `.txt` files were placed into a single directory named `corpus_data`.
2.The `mfa validate` command was used to check the corpus and identify out-of-vocabulary (OOV) words.
    ```bash
>>First, download the model to validate against
  mfa model download dictionary english_us_arpa.
    
>>Run the validation
  mfa validate corpus_data english_us_arpa
    
3.) Running the Pipeline

The full pipeline involves generating a custom dictionary and then running the alignment.

>>Step 3a: Generate Custom Dictionary (Extra Credit)

To handle the OOV words found during validation, a G2P (Grapheme-to-Phoneme) model was used to create
a `custom_dictionary.txt` file.

```bash
>> Download the G2P model
mfa model download g2p english_us_arpa

>> Run G2P to create the dictionary
mfa g2p corpus_data english_us_arpa custom_dictionary.txt

>> Step 3b: Run Alignment (Model 1: `english_us_arpa`)

The first alignment was run using the `english_us_arpa` acoustic model.

```bash
>> Download the acoustic model
mfa model download acoustic english_us_arpa

>> Run the alignment
mfa align corpus_data custom_dictionary.txt english_us_arpa mfa_outputs

> Outputs are saved in the `mfa_outputs` folder.

>> Step 3c: Run Alignment (Model 2: `english_mfa`) (Extra Credit)

A second alignment was run using the `english_mfa` acoustic model for comparison.

```bash
>> Download the acoustic model
mfa model download acoustic english_mfa

>> Run the alignment
mfa align corpus_data custom_dictionary.txt english_mfa mfa_outputs_2

> Outputs are saved in the `mfa_outputs_2` folder.

4.) Automating the Full Pipeline (Extra Credit)

A Windows batch file, `run_pipeline.bat`, was created to automate steps 3a, 3b, and 3c. 
After activating the Conda environment (see Step 1), this script can be run:

```bash
>> Make sure you are in the project directory
cd path/to/MFA_Assignment

>> Run the automated script
run_pipeline.bat

5.) Analysis

The resulting ‘. TextGrid’ files in the `mfa_outputs` and `mfa_outputs_2` folders were inspected using
Praat. Both audio files and their corresponding TextGrids were opened simultaneously to check for 
alignment accuracy and errors.

Key Finding 1 (Success): The acoustic model is highly accurate on standard words. Phrases with difficult stop consonants (like`I’ said white not bait`) were aligned perfectly, with boundaries correctly placed in the silent gaps. 

Key Finding 2 (Failure): The pipeline's main weakness is the G2P model. It failed on complex, non-standard words: Catastrophic Failure: For "de-politicize", the G2P model produced no phonemes, forcing the aligner to label the entire word as "spoken noise" (`spn`). Misalignment: For proper nouns like "Dukakis" the G2P model generated incorrect pronunciations. This forced the aligner to produce a completely jumbled, nonsensical alignment. Minor Errors: For acronyms like "S.J.C.'s", the aligner "stole" phonemes from one word and attached them to the next.


