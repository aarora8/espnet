#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail


train_set=train
valid_set=dev
test_sets=eval

asr_config=conf/train_asr_transformer.yaml
inference_config=conf/decode_asr_transformer.yaml
lm_config=conf/train_lm.yaml

#asr_config=conf/tuning/train_asr_transformer4.yaml
#lm_config=conf/tuning/train_lm_transformer2.yaml
#inference_config=conf/tuning/decode_transformer2.yaml

use_word_lm=false
word_vocab_size=65000
speed_perturb_factors="0.9 1.0 1.1"

./asr.sh                                                 \
    --lang en                                            \
    --use_lm true                                        \
    --nbpe 100                                           \
    --max_wav_duration 30                                \
    --lm_config "${lm_config}"                           \
    --asr_config "${asr_config}"                         \
    --inference_config "${inference_config}"             \
    --token_type char                                    \
    --feats_type fbank_pitch                             \
    --use_word_lm ${use_word_lm}                         \
    --word_vocab_size ${word_vocab_size}                 \
    --train_set "${train_set}"                           \
    --valid_set "${valid_set}"                           \
    --test_sets "${test_sets}"                           \
    --speed_perturb_factors "${speed_perturb_factors}"   \
    --lm_train_text "data/${train_set}/text"             \
    --bpe_train_text "data/${train_set}/text" "$@" 
