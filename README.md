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


🚀 Características Principales
    Orquestador Inteligente (n8n): Monitorea la base de datos buscando tablas creadas hace más de 10 días que no han sido auditadas.
    
    Clasificación Híbrida: Combina reglas SQL rápidas con la inferencia semántica de Google Gemini 1.5 Flash.
    
    Protección de Datos: Genera vistas de base de datos donde los campos sensibles son automáticamente ofuscados (SHA256, Máscaras) según su nivel de sensibilidad.
    
    Infraestructura como Código: Despliegue completo con Docker Compose. Incluye datos semilla y un entorno de "empresa ficticia" para pruebas.

🛠️ Instalación y Despliegue
    Prerrequisitos:
    Docker y Docker Compose
    Una API Key de Google AI Studio
    
    Paso a Paso
        1. Clonar el repositorio
            git clone [https://github.com/Joelspitale/data-gov-automator.git](https://github.com/Joelspitale/data-gov-automator.git)
            cd data-gov-automator
    
        2. Configurar Variables de Entorno Copia el archivo de ejemplo y configura tu API Key.
            cp .env.example .env
            # Edita el archivo .env y pega tu GOOGLE_GEMINI_API_KEY
    
        3. Iniciar Infraestructura (Esto levantará MySQL, creará automáticamente el esquema de Gobierno (AR_PROD_HUB_EXT), poblará los datos maestros y generará una base de datos de prueba (AR_PROD_HUB_DIM) con clientes ficticios.)
            docker-compose up -d
    
        4. Configurar n8n
            Ingresa a http://localhost:5678
            Configura tu usuario admin.
            Importa los archivos JSON de la carpeta /workflows.
            Importante: En las credenciales de n8n, crea una para "Google Gemini" y usa la expresión {{ $env.GOOGLE_GEMINI_API_KEY }}.

¡Excelente iniciativa, Joel! He revisado mentalmente la estructura de tu proyecto y, para que tu README pase de ser "una guía de instalación" a una presentación de portafolio profesional, necesitas agregar elementos visuales y explicar el "porqué" de tu lógica.

Un buen README no solo dice cómo instalarlo, sino que vende la inteligencia detrás del código.

Aquí tienes 5 mejoras concretas y el código Markdown listo para copiar.

1. Diagrama de Arquitectura (Mermaid)
GitHub soporta nativamente gráficos hechos con código (Mermaid). Esto explica visualmente cómo interactúan Docker, n8n, MySQL y Gemini sin que tengas que dibujar nada en Paint.

2. Badges (Insignias)
Dan un look muy "pro" al principio del archivo. Indican las tecnologías usadas de un vistazo.

3. Explicación del Algoritmo de Decisión
Tu proyecto tiene una lógica muy valiosa: Determinístico vs Probabilístico.

Primero buscas match exacto (Rápido/Barato).

Luego match parcial.

Solo al final usas IA (Costoso/Inteligente). Explicar esto demuestra que te preocupas por la performance y los costos.

4. Capturas de Pantalla (Screenshots)
Una imagen de tu flujo de n8n complejo vale más que mil palabras.

Tarea para ti: Saca una captura de tu flujo en n8n y guárdala como n8n-workflow.png en una carpeta /docs o súbela a los "Issues" de GitHub para obtener un link.

5. Roadmap (Futuro)
Muestra que tienes visión de cómo escalar el producto (ej: agregar notificaciones a Slack/Teams).

El Código para tu nuevo README.md
Copia y pega todo el bloque siguiente en tu archivo README.md. He incluido el gráfico automático en la sección de "Flujo de Trabajo".

Markdown

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
🚀 Características Principales
Orquestador Inteligente (n8n): Monitorea la base de datos buscando tablas creadas hace más de 10 días que no han sido auditadas.

Clasificación Híbrida: Combina reglas SQL rápidas con la inferencia semántica de Google Gemini 1.5 Flash.

Protección de Datos: Genera vistas de base de datos donde los campos sensibles son automáticamente ofuscados (SHA256, Máscaras) según su nivel de sensibilidad.

Infraestructura como Código: Despliegue completo con Docker Compose. Incluye datos semilla y un entorno de "empresa ficticia" para pruebas.

🛠️ Instalación y Despliegue
Prerrequisitos
Docker y Docker Compose

Una API Key de Google AI Studio

Paso a Paso
Clonar el repositorio

Bash

git clone [https://github.com/Joelspitale/data-gov-automator.git](https://github.com/Joelspitale/data-gov-automator.git)
cd data-gov-automator
Configurar Variables de Entorno Copia el archivo de ejemplo y configura tu API Key.

Bash

cp .env.example .env
# Edita el archivo .env y pega tu GOOGLE_GEMINI_API_KEY
Iniciar Infraestructura

Bash

docker-compose up -d
Esto levantará MySQL, creará automáticamente el esquema de Gobierno (AR_PROD_HUB_EXT), poblará los datos maestros y generará una base de datos de prueba (AR_PROD_HUB_DIM) con clientes ficticios.

Configurar n8n

Ingresa a http://localhost:5678

Configura tu usuario admin.

Importa los archivos JSON de la carpeta /workflows.

Importante: En las credenciales de n8n, crea una para "Google Gemini" y usa la expresión {{ $env.GOOGLE_GEMINI_API_KEY }}.

📂 Estructura del Proyecto
/workflows: Lógica de negocio (JSONs de n8n).
    Databases.json: Orquestador que busca tablas nuevas.
    RegistroAndDeteccion...json: El cerebro que clasifica los datos.

/sql: Scripts de inicialización (se ejecutan automáticamente en orden alfabético).
    01_governance_schema.sql: Estructura Fisica del catálogo de datos sensibles.
    02_governance_seeds.sql: Reglas de sensibilidad pre-cargadas.
    03_demo_business_schema: Base de datos "dummy" para probar el sistema.
    04_demo_business_data: Datos a cargar en modelo de negocio.
    
docker-compose.yml: Definición de servicios.
