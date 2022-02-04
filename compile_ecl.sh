file_name="scout/compile_scout.ecl"

eclcc -S $file_name -I "scout" -w2168=ignore -w2003=ignore -w2007=ignore -w2364=ignore -w4531=ignore -w4522=ignore -w4523=ignore -w4538=ignore -w4515=ignore -w4214=ignore

    if [[ $? == 0 ]]; then
        echo "success $CI_COMMIT_TITLE submitted by $GITLAB_USER_NAME"
    else
        echo "fail $CI_COMMIT_TITLE submitted by $GITLAB_USER_NAME";
        exit 1;
    fi 
