#!/usr/bin/env bash
# Set bash to 'debug' mode, it will exit on :
# -e 'error', -u 'undefined variable', -o ... 'error in pipeline', -x 'print commands',
set -e
set -u
set -o pipefail

train_set="train"
valid_set="dev"
test_sets="dev"

asr_config=conf/train_asr.yaml
lm_config=conf/train_lm.yaml
inference_config=conf/decode_asr.yaml

#  --use_word_lm false                                                                                         \
#  --speed_perturb_factors "0.9 1.0 1.1"                                                                       \
#  --audio_format wav                                                                                          \
#  --use_lm true                                                                                               \

./asr.sh                                                                                                       \
    --lang en                                                                                                  \
    --audio_format wav                                                                                         \
    --max_wav_duration 30                                                                                      \
    --speed_perturb_factors "0.9 1.0 1.1"                                                                      \
    --token_type bpe                                                                                           \
    --nbpe 5000                                                                                                \
    --use_lm true                                                                                              \
    --lm_config "${lm_config}"                                                                                 \
    --asr_config "${asr_config}"                                                                               \
    --inference_config "${inference_config}"                                                                   \
    --train_set "${train_set}"                                                                                 \
    --valid_set "${valid_set}"                                                                                 \
    --test_sets "${test_sets}"                                                                                 \
    --lm_train_text "data/${train_set}/text"                                                                   \
    --bpe_train_text "data/${train_set}/text" "$@"                                                             \
    --nj 128                                                                                                   \
    --inference_nj 128                                                                                         \
    --ngpu 1                                                                                                   \
    --local_score_opts "--use_lm true"
