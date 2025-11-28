# 🛡️ Data Governance & PII Automator

![n8n Version](https://img.shields.io/badge/n8n-1.118.0-FF6B6B?style=for-the-badge&logo=n8n)
![MySQL](https://img.shields.io/badge/MySQL-8.0-4479A1?style=for-the-badge&logo=mysql)
![Gemini AI](https://img.shields.io/badge/AI-Google%20Gemini-4285F4?style=for-the-badge&logo=google)
![Docker](https://img.shields.io/badge/Docker-Compose-2496ED?style=for-the-badge&logo=docker)

> **Sistema automatizado para la detección, clasificación y protección de Datos Sensibles (PII) utilizando orquestación de flujos y LLMs.**

Este proyecto resuelve el problema del **Gobierno de Datos** en entornos dinámicos: detecta automáticamente nuevas tablas en la base de datos, analiza su contenido para identificar información sensible (Emails, DNI, Tarjetas) y genera un catálogo de datos actualizado sin intervención humana.

---

## 🧠 Arquitectura y Lógica

El sistema no utiliza IA para todo (lo cual sería lento y costoso). Implementa una **Lógica de Clasificación en Cascada**:

```mermaid
graph TD
    A[Cron: Nuevas Tablas] -->|Detecta cambios| B(Scan Metadata MySQL)
    B --> C{¿Existe en Catálogo?}
    C -->|Si| D[Fin]
    C -->|No| E[Analizar Columnas]
    
    E --> F{1. Match Literal}
    F -->|Si| G[Clasificar: PII Detectado]
    F -->|No| H{2. Match Parcial 'LIKE'}
    
    H -->|Si| G
    H -->|No| I[3. Consultar a Google Gemini AI]
    
    I -->|Prompt con 5 muestras| J{¿Es Sensible?}
    J -->|No| K[Marcar como No Sensible]
    J -->|Si| L[Crear Nuevo Concepto en Maestro]
    
    G --> M[Actualizar Catálogo]
    L --> M
    M --> N[Generar Vistas Encriptadas]
