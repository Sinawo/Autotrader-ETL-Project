# Autotrader Data Analysis Project

## Overview

This project aims to perform data analysis on car listings from the Autotrader website ([https://www.autotrader.co.za/](https://www.autotrader.co.za/)). The goal is to collect data, analyze it, and create a comprehensive report to estimate and forecast car prices.

## Project Steps

### 1. Data Collection

We start by scraping data from the Autotrader website using a Python script named `ssms-scraper.py`. This script collects important information about the cars listed on the site. Given that the website has approximately 5000 pages, each containing at least 20 cars, the script is designed to efficiently handle and extract data from all pages.

- **Data Source**: [Autotrader Cars for Sale](https://www.autotrader.co.za/cars-for-sale?priceoption=RetailPrice)
- **Script**: `ssms-scraper.py`
- **Technology**: Python

### 2. Data Pipeline

To automate the data collection and processing, we have set up a pipeline using an Azure YAML file (`azure-pipelines.yml`). This pipeline runs every hour, executing the scraping script and SQL stored procedures to clean and organize the data.

- **Pipeline Configuration**: `azure-pipelines.yml`
- **Schedule**: Every hour
- **Technology**: Azure DevOps, SQL Server Management Studio (SSMS)

### 3. Data Storage and Analysis

The cleaned data is stored in SQL Server Management Studio (SSMS). We connect Power BI to SSMS to query the data and create interactive dashboards for data visualization and analysis.

- **Data Storage**: SQL Server Management Studio (SSMS)
- **Data Visualization**: Power BI

## Usage

To run the project locally or contribute, follow these steps:

1. **Clone the repository**:
    ```bash
    git clone https://github.com/username/autotrader-data-analysis.git
    ```

2. **Navigate to the project directory**:
    ```bash
    cd autotrader-data-analysis
    ```

3. **Set up your Python environment and install dependencies**:
    ```bash
    pip install -r requirements.txt
    ```

4. **Run the scraping script**:
    ```bash
    python ssms-scraper.py
    ```
