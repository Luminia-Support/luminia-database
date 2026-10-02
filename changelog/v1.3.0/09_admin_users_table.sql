--liquibase formatted sql

--changeset luminia-architect:09-admin-users-table runInTransaction:true
--comment: Creacion de tabla dedicada para personal administrativo interno (Segregacion RBAC)

CREATE TABLE IF NOT EXISTS admin_users (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    firebase_uid VARCHAR(128) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    full_name VARCHAR(150) NOT NULL,
    role VARCHAR(30) NOT NULL CHECK (role IN ('ADMIN', 'SUPERADMIN')),
    is_active BOOLEAN NOT NULL DEFAULT TRUE,
    created_by VARCHAR(128),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_admin_users_email ON admin_users(email);
CREATE INDEX IF NOT EXISTS idx_admin_users_firebase_uid ON admin_users(firebase_uid);
CREATE INDEX IF NOT EXISTS idx_admin_users_role ON admin_users(role);

--rollback DROP TABLE IF EXISTS admin_users;
