#!/bin/sh

# Exit when any command fails:
set -e

mongo -- "${MONGO_INITDB_DATABASE}" <<EOF
    const rootUsername = '${MONGO_INITDB_ROOT_USERNAME}';
    const rootPassword = '${MONGO_INITDB_ROOT_PASSWORD}';
    const admin = db.getSiblingDB('admin');
    admin.auth(rootUsername, rootPassword);

    const userUsername = '${MONGO_INITDB_USER_USERNAME}';
    const userPassword = '${MONGO_INITDB_USER_PASSWORD}';
    db.createUser({ user: userUsername, pwd: userPassword, roles: ["readWrite"] });
EOF
