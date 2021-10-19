#!/usr/bin/env bash

set -e
set -u
set -o pipefail

lm_exp=
inference_tag=
inference_config=
inference_args=
use_lm=
inference_lm=valid.loss.ave.pth
inference_asr_model=valid.acc.ave.pth
test_sets="dev eval"

. ./path.sh || exit 1;
. ./cmd.sh || exit 1;
. ./utils/parse_options.sh || exit 1;
if [ $# -ne 1 ]; then
    echo "Usage:  <asr_exp> "
fi

asr_exp=$1
if [ -n "${test_sets}" ]; then
    for dset in ${test_sets}; do
        _dir="${asr_exp}/${inference_tag}/${dset}"
        for _type in cer wer ter; do
            _scoredir="${_dir}/score_${_type}"
            python local/scoring_util.py ${_scoredir}/ref.trn ${_scoredir}/hyp.trn ${_scoredir}
        done
    done
fi
