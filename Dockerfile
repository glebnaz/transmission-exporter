# Указываем базовый образ для сборки
FROM golang:1.22 AS builder

# Указываем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем go.mod и go.sum для установки зависимостей
COPY go.mod go.sum ./

# Устанавливаем зависимости
RUN go mod download

# Копируем исходный код
COPY . .

# Устанавливаем GOARCH и GOOS для сборки под ARM архитектуру (Raspberry Pi)
ENV GOARCH=arm
ENV GOARM=7
ENV GOOS=linux

# Собираем приложение
RUN go build -o app .

# Создаем минимальный образ для выполнения
FROM debian:bullseye-slim

# Указываем рабочую директорию внутри контейнера
WORKDIR /app

# Копируем собранное приложение из этапа builder
COPY --from=builder /app/app .

# Указываем порт, который будет слушать приложение (при необходимости)
EXPOSE 8080

# Устанавливаем команду по умолчанию
CMD ["./app"]
