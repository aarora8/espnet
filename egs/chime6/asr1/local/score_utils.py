#!/usr/bin/env python3
import os
import argparse

conversational_filler = ['UH', 'UHH', 'UM', 'EH', 'MM', 'HM', 'MHM', 'MMM', 'HMM', 'AH', 'HUH', 'HA', 'ER', 'OOF', 'HEE' , 'ACH', 'EEE', 'EW', 'mhm', 'mm', 'mmm']
unk_tags = ['<UNK>', '<unk>']
gigaspeech_punctuations = ['<COMMA>', '<PERIOD>', '<QUESTIONMARK>', '<EXCLAMATIONPOINT>', '[INAUDIBLE]', '[LAUGHS]', '[NOISE]', '[inaudible]', '[laughs]', '[noise]' ]
gigaspeech_garbage_utterance_tags = ['<SIL>', '<NOISE>', '<MUSIC>', '<OTHER>']
non_scoring_words = unk_tags + gigaspeech_punctuations + gigaspeech_garbage_utterance_tags

def asr_text_post_processing(text):
    # convert to uppercase
    # remove non-scoring words from evaluation
    text = text.upper()
    remaining_words = []
    for word in text.split():
        if word in non_scoring_words:
            continue
        if word in conversational_filler:
            word = 'HMM'
        remaining_words.append(word)

    return ' '.join(remaining_words)

if __name__ == '__main__':
    parser = argparse.ArgumentParser(description="This script evaluates ASR result via SCTK's tool sclite")
    parser.add_argument('ref', type=str, help="sclite's standard transcription(trn) reference file")
    parser.add_argument('hyp', type=str, help="sclite's standard transcription(trn) hypothesis file")
    parser.add_argument('work_dir', type=str, help='working dir')
    args = parser.parse_args()
    if not os.path.isdir(args.work_dir):
        os.mkdir(args.work_dir)

    REF = os.path.join(args.work_dir, 'REF')
    HYP = os.path.join(args.work_dir, 'HYP')
    RESULT = os.path.join(args.work_dir, 'RESULT')

    output_text_handle = open(REF, 'w', encoding='utf8')
    arc_post_handle = open(args.ref, 'r', encoding='utf8')
    for line in arc_post_handle:
        words = line.strip().split(' ')
        text = asr_text_post_processing(' '.join(words[:-1]))
        uttid_field = words[-1]
        transcription = text + ' ' + uttid_field
        output_text_handle.write(transcription + '\n')


    output_text_handle = open(HYP, 'w', encoding='utf8')
    arc_post_handle = open(args.hyp, 'r', encoding='utf8')
    for line in arc_post_handle:
        cols = line.strip().split(' ')
        text = asr_text_post_processing(' '.join(cols[:-1]))
        uttid_field = cols[-1]
        transcription = text + ' ' + uttid_field
        output_text_handle.write(transcription + '\n')
    
    os.system(F'sclite -r {REF} trn -h {HYP} trn -i rm -o all stdout > {RESULT}')
