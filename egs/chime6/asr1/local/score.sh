#!/usr/bin/env bash

set -e
set -u
set -o pipefail


. ./path.sh || exit 1;
. ./cmd.sh || exit 1;
. ./utils/parse_options.sh || exit 1;
#_dir=exp/train_worn_simu_u400k_cleaned_trim_sp_pytorch_train/decode_dev_gss/
_dir=exp/train_worn_simu_u400k_cleaned_trim_sp_pytorch_train_vggblstm/decode_dev_gss/
python3 local/score_utils.py ${_dir}/ref.trn ${_dir}/hyp.trn ${_dir}
