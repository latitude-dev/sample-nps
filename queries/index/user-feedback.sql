select *
from { ref('init') }
where user_id = { param('user_id', 166) }
order by formatted_timestamp desc