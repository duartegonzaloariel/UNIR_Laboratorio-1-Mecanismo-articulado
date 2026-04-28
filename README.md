# 🦾 Laboratorio 1: Mecanismo Articulado

Análisis cinemático de un mecanismo articulado de tres barras mediante técnicas numéricas. Se estiman derivadas por diferencias finitas, se interpola con polinomios de Lagrange y se aproxima la relación entre ángulos con una red neuronal, comparando los resultados con la solución analítica exacta.

---

## 📐 Descripción del problema

El mecanismo está compuesto por tres eslabones articulados con parámetros:

| Parámetro | Valor |
|-----------|-------|
| `a` | 100 mm |
| `b` | 120 mm |
| `c` | 150 mm |
| `d` | 180 mm |

La relación entre los ángulos α y β queda descrita por la ecuación implícita:

(d - a·cos(α) - b·cos(β))² + (a·sin(α) + b·sin(β))² - c² = 0

---

## 🧮 Métodos implementados

- **Diferencias finitas de orden 2**: progresivas, regresivas y centrales para estimar dβ/dα
- **Interpolación de Lagrange**: estimación de β en α = 17°
- **Interpolación polinomial**: cálculo de la segunda derivada d²β/dα² en α = 17°
- **Verificación analítica**: diferenciación implícita y Newton-Raphson
- **Red neuronal artificial**: aproximación de β(α) con Deep Learning Toolbox

---

## 📊 Resultados principales

| Método | β(17°) (rad) | Error relativo |
|--------|-------------|----------------|
| Analítico exacto | 1.243089 | — |
| Interpolación de Lagrange | 1.243136 | 0.0038% |
| Red neuronal | 1.243367 | 0.0224% |

---

## 🗂️ Estructura del repositorio

📁 /
├── 📄 main.tex
├── 📄 referencias.bib
├── 📁 codigo/
│   ├── 📝 DiferenciaFinitas.m
│   ├── 📝 Lagrange.m
│   ├── 📝 Polinomio.m
│   └── 📝 RedNeuronal.m
└── 📁 figuras/
    ├── 🖼️ ejercicio1.png
    ├── 🖼️ beta_vs_alpha.png
    ├── 🖼️ derivada.png
    ├── 🖼️ Lagrange.png
    ├── 🖼️ Polinomio.png
    └── 🖼️ red_neuronal.png

---

## 🛠️ Requisitos

- MATLAB R2021a o superior
- Deep Learning Toolbox *(solo para `RedNeuronal.m`)*

---

## 👤 Autor

**Gonzalo Duarte**
Máster Universitario en Ingeniería Matemática y Computación
Métodos Numéricos Aplicados
