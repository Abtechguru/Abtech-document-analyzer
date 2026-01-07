#!/bin/bash
# Initialize database with sample data

echo "Waiting for PostgreSQL to start..."
./scripts/wait-for-it.sh postgres 5432

echo "Running database migrations..."
cd backend && alembic upgrade head

echo "Creating initial admin user..."
python -c "
from app.db.session import SessionLocal
from app.models.user import User
from app.core.security import get_password_hash

db = SessionLocal()
try:
    if not db.query(User).filter(User.email == 'admin@docanalyzer.com').first():
        admin = User(
            email='admin@docanalyzer.com',
            username='admin',
            full_name='Administrator',
            hashed_password=get_password_hash('Admin123!'),
            is_superuser=True,
            is_active=True
        )
        db.add(admin)
        db.commit()
        print('Admin user created successfully')
    else:
        print('Admin user already exists')
finally:
    db.close()
"

echo "Database initialization complete!"