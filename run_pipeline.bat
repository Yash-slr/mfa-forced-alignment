@ECHO OFF
ECHO [MFA Pipeline] Starting...

ECHO (Step 1 of 3) Generating custom dictionary...
mfa g2p corpus_data english_us_arpa custom_dictionary.txt

ECHO (Step 2 of 3) Aligning with 'english_us_arpa' model...
mfa align corpus_data custom_dictionary.txt english_us_arpa mfa_outputs

ECHO (Step 3 of 3) Aligning with 'english_mfa' model...
mfa align corpus_data custom_dictionary.txt english_mfa mfa_outputs_2

ECHO [MFA Pipeline] All tasks complete!
PAUSE