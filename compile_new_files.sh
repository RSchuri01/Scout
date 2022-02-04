ci_status=1

for filename in `git diff --name-only $CI_COMMIT_BEFORE_SHA $CI_COMMIT_SHA`; do
    if [[ ${filename: -4} == *.ecl ]]; then
        eclcc $filename -I "scout" -w2168=ignore -w2003=ignore -w2007=ignore -w2364=ignore -w4531=ignore -w4522=ignore -w4523=ignore -w4538=ignore -w4515=ignore -w4214=ignore
            if [[ $? == 0 ]]; then
                echo "Pass $filename"
            else
                ci_status=0
                echo "fail $filename"
            fi
    fi       
done
if [[ $ci_status == 1 ]]; then
    exit 0;
else
    exit 1;
fi