select *,
       STRFTIME('%d %b %Y', timestamp) as formatted_timestamp
from read_csv_auto('queries/data.csv')
