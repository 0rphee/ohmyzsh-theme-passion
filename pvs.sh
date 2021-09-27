nfiles=$(find ../public_examples | wc -l)
# zip -r aa.zip ../public_examples | pv -s $nfiles -l
# # zip -r aa.zip ../unuseless | tqdm --total $((nfiles + 1)) --unit files --null
# zip -r aa.zip tmp | tqdm --total $(find tmp | wc -l) --unit files --null --bar-format \
# 'progress: {n_fmt}/{total_fmt} <{bar:u}> {percentage:3.0f}% ({elapsed}<{remaining}-{rate_fmt}{postfix})' \
# --dynamic-ncols
zip -r aa.zip ../public_examples | tqdm --total $nfiles --unit files --null --dynamic-ncols --ascii '.>' --bar-format \
'progress: {n_fmt}/{total_fmt} [{bar}] {percentage:3.0f}% ({remaining} {rate_fmt})' \

 
# nfiles=$( unzip -Z -1 aa.zip | wc -l )
# unzip -d ./aa | pv -l -s ${nfiles}
# unzip -o aa.zip | tqdm --total $((nfiles + 1)) --unit files --null --dynamic-ncols --bar-format \
# 'progress: {n_fmt}/{total_fmt}[{bar}]{percentage:3.0f}%[{elapsed}<{remaining},{rate_fmt}{postfix}] {remaining_s}' \
# --ascii
# local _ncols="$(( $COLUMNS / 2 ))"
# seq 4 1 200 | tqdm --total 200 --null --ncols "$(( $COLUMNS / 2 ))" --ascii "*>" --bar-format "progress: {n_fmt}/{total_fmt}[{bar}]{percentage:3.0f}% ({remaining}, {rate_fmt})"