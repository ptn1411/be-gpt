pub mod auth;
pub mod bot_api;
pub mod botfather;
pub mod bots;
pub mod chats;
pub mod invite_links;
pub mod metrics;
pub mod settings;
pub mod upload;
pub mod users;
pub mod ws;

use crate::AppState;
use axum::Router;
use std::sync::Arc;

pub fn api_routes() -> Router<Arc<AppState>> {
    Router::new()
        .nest("/auth", auth::routes())
        .nest("/users", users::routes())
        .nest("/chats", chats::routes())
        .nest("/settings", settings::routes())
        .nest("/upload", upload::routes())
        .nest("/ws", ws::routes())
        .nest("/bots", bots::routes())
        .nest("/botfather", botfather::routes())
        .nest("/metrics", metrics::routes())
        .nest("/invite-links", invite_links::routes())
}

/// Bot API routes (Telegram-style /bot:token/* endpoints)
pub use bot_api::bot_api_routes;
