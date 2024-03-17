select user_list.user_id,
       user_list.count,
       user_list.last_feedback,
       user_list.last_score,
       user_list.avg_last_3_votes
from (
    select user_id,
           count(*) as count,
           max(formatted_timestamp) as last_feedback,
           ANY_VALUE(last_score) as last_score,
           ANY_VALUE(avg_last_3_votes) as avg_last_3_votes
    from (
        select user_id,
               formatted_timestamp,
               first_value(score) over (partition by user_id order by timestamp desc) as last_score,
               avg(score) over (partition by user_id order by timestamp desc rows between 2 preceding and current row) as avg_last_3_votes
        from { ref('init') }
    ) as subquery
    group by user_id
) as user_list
join (
    select user_id
    from { ref('init') }
    group by user_id
    order by count(*) desc
    limit 20
) as top_users
on user_list.user_id = top_users.user_id
order by user_list.last_feedback desc, user_list.last_score asc, user_list.avg_last_3_votes asc
