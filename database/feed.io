// Database of Feed service - Redis

hot_feed (redis list):
	user_id => [ post_metadata, post_metadata, ... ] x20

warm_feed (redis list):
	user_id => [ post_id, post_id, ... ]