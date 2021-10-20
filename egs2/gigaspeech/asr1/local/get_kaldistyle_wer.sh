#!/usr/bin/env bash
# Copyright 2012-2014  Johns Hopkins University (Author: Daniel Povey, Yenda Trmal)
# Apache 2.0

[ -f ./path.sh ] && . ./path.sh

# begin configuration section.
cmd=run.pl
stage=0
#end configuration section.

echo "$0 $@"  # Print the command line for logging
[ -f ./path.sh ] && . ./path.sh
. parse_options.sh || exit 1;

data=$1
dir=$3

ref_filtering_cmd="cat"
[ -x local/wer_output_filter ] && ref_filtering_cmd="local/wer_output_filter"
[ -x local/wer_ref_filter ] && ref_filtering_cmd="local/wer_ref_filter"
hyp_filtering_cmd="cat"
[ -x local/wer_output_filter ] && hyp_filtering_cmd="local/wer_output_filter"
[ -x local/wer_hyp_filter ] && hyp_filtering_cmd="local/wer_hyp_filter"

mkdir -p $dir/scoring_kaldi

if [ $stage -le 1 ]; then

    $cmd $dir/scoring_kaldi/stats1.log \
      cat $dir/sco \| \
      align-text --special-symbol="'***'" ark:ref1 ark:hyp1 ark,t:- \|  \
      utils/scoring/wer_per_utt_details.pl --special-symbol "'***'" \| tee $dir/scoring_kaldi/wer_details/per_utt \|\
       utils/scoring/wer_per_spk_details.pl $data/utt2spk \> $dir/scoring_kaldi/wer_details/per_spk || exit 1;

    $cmd $dir/scoring_kaldi/log/stats2.log \
      cat $dir/scoring_kaldi/wer_details/per_utt \| \
      utils/scoring/wer_ops_details.pl --special-symbol "'***'" \| \
      sort -b -i -k 1,1 -k 4,4rn -k 2,2 -k 3,3 \> $dir/scoring_kaldi/wer_details/ops || exit 1;

    $cmd $dir/scoring_kaldi/log/wer_bootci.log \
      compute-wer-bootci --mode=present \
        ark:$dir/scoring_kaldi/test_filt.txt ark:$dir/scoring_kaldi/penalty_$best_wip/$best_lmwt.txt \
        '>' $dir/scoring_kaldi/wer_details/wer_bootci || exit 1;
fi

exit 0;
