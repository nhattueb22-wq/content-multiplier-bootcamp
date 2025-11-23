-- 1. Dọn dẹp bảng cũ
DROP TABLE IF EXISTS document_chunks;
DROP TABLE IF EXISTS documents;
DROP TABLE IF EXISTS knowledge_chunks;
DROP TABLE IF EXISTS knowledge_document_categories;
DROP TABLE IF EXISTS knowledge_documents;
DROP TABLE IF EXISTS knowledge_categories;

-- 2. Bật Vector
CREATE EXTENSION IF NOT EXISTS vector;

-- 3. Tạo bảng Danh mục
CREATE TABLE knowledge_categories (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL,
    description TEXT,
    color TEXT DEFAULT '#3B82F6',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 4. Tạo bảng Tài liệu (CHUẨN TÊN THEO CODE)
CREATE TABLE knowledge_documents (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    filename TEXT NOT NULL,
    file_path TEXT NOT NULL,
    file_type TEXT NOT NULL,
    file_size BIGINT,
    content_text TEXT,
    metadata JSONB DEFAULT '{}',
    status TEXT DEFAULT 'processing',
    user_id INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 5. Tạo bảng Trung gian
CREATE TABLE knowledge_document_categories (
    document_id INTEGER REFERENCES knowledge_documents(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES knowledge_categories(id) ON DELETE CASCADE,
    PRIMARY KEY (document_id, category_id)
);

-- 6. Tạo bảng Chunks (CHUẨN TÊN THEO CODE)
CREATE TABLE knowledge_chunks (
    id SERIAL PRIMARY KEY,
    document_id INTEGER REFERENCES knowledge_documents(id) ON DELETE CASCADE,
    chunk_text TEXT,
    chunk_index INTEGER,
    token_count INTEGER,
    embedding vector(1536),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);