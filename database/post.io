// Database of Post service - PostgreSQL

Table posts {
  id integer [primary key]
  description text
  latitude double
  longitude double
  created_by_user_id integer
  created_at timestamp
}

Table photos {
  id integer [primary key]
  post_id integer
  photo_url integer
}

Table reactions_by_users
{
  post_id integer [primary key]
  reaction_id integer [primary key]
  created_by_user_id integer [primary key]
  created_at timestamp
}

Table reactions_aggregated
{
  post_id integer [primary key]
  reaction_id integer [primary key]
  count integer
}

Table reactions_dictionary
{
  id integer [primary key]
  icon_url text [note: 'Url of reaction icon']
}

Table post_outbox {
  post_data bytes
}

Ref: reactions_by_users.post_id > posts.id

Ref: reactions_by_users.reaction_id > reactions_dictionary.id

Ref: photos.post_id > posts.id

Ref: reactions_aggregated.post_id > posts.id

Ref: reactions_aggregated.reaction_id > reactions_dictionary.id
