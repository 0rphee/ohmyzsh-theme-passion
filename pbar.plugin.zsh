function tqdm_pbar(){
  tqdm --total $1 --unit files --null --dynamic-ncols --ascii '·>' --bar-format \
'progress: {n_fmt}/{total_fmt} [{bar}] {percentage:3.0f}% ({remaining})'
}

function pbar_cpdir(){
  local nfiles=$(find $1 | wc -l)
  cp -vr $1 $2 | tqdm_pbar $nfiles
}

# function pbar_mvdir(){
#   local nfiles=$(find $1 | wc -l)
#   mv -v $1 $2 | tqdm_pbar $nfiles
# }

function pbar_zipdir(){
  local nfiles=$(find $2 | wc -l)
  zip -r $1 $2 | tqdm_pbar $nfiles
}

function pbar_unzipdir(){
  local nfiles=$( unzip -Z -1 $1 | wc -l )
  unzip -o $1 | tqdm_pbar $(( nfiles + 1 ))
  wait
}

# function pbar_tardir(){

# }

# function pbar_untardir(){

# }

# pbar_cpdir ../public_examples ./tmp/
# pbar_mvdir tmp/public_examples ./
# pbar_zipdir aa.zip tmp/public_examples
pbar_unzipdir aa.zip
# pbar_mvdir $_path
# pbar_zipdir $_path
# pbar_tardir $_path
# pbar_untardir $_path