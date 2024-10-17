// Database of Subscription service - Redis

user_subscribed_to (redis list): // Ключ - пользователь, который подписан на пользователей в списке
	user_id => [ user_id, user_id, ... ]

subscribed_to_user (redis list): // Ключ - пользователь, на которого подписаны пользователи из списка
    user_id => [ user_id, user_id, ... ]

new_subscription_outbox (redis list):
    [ { user_id => user_id }, { user_id => user_id } ... ]