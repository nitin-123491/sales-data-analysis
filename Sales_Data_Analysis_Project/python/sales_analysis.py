import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv("../data/sales_data.csv", parse_dates=["Date"])

# Basic cleaning
df = df.drop_duplicates()
df["Sales"] = pd.to_numeric(df["Sales"], errors="coerce")
df["Profit"] = pd.to_numeric(df["Profit"], errors="coerce")
df = df.dropna(subset=["Sales", "Profit"])

# KPIs
print("Total Sales:", round(df["Sales"].sum(), 2))
print("Total Profit:", round(df["Profit"].sum(), 2))
print("Total Orders:", len(df))
print("Total Quantity:", int(df["Quantity"].sum()))
print("Average Order Value:", round(df["Sales"].mean(), 2))

# Product analysis
product_sales = df.groupby("Product")["Sales"].sum().sort_values(ascending=False)
print("\nTop Products:\n", product_sales.head(5))

# Monthly trend
monthly_sales = df.groupby(df["Date"].dt.to_period("M"))["Sales"].sum()
monthly_sales.index = monthly_sales.index.astype(str)
plt.figure(figsize=(9,5))
monthly_sales.plot(kind="line", marker="o")
plt.title("Monthly Sales Trend")
plt.xlabel("Month")
plt.ylabel("Sales")
plt.xticks(rotation=45)
plt.tight_layout()
plt.savefig("../charts/monthly_sales.png", dpi=150)
plt.close()

# Top products chart
plt.figure(figsize=(9,5))
product_sales.head(5).sort_values().plot(kind="barh")
plt.title("Top 5 Products by Sales")
plt.xlabel("Sales")
plt.tight_layout()
plt.savefig("../charts/top_products.png", dpi=150)
plt.close()

# City analysis
city_sales = df.groupby("City")["Sales"].sum().sort_values(ascending=False)
plt.figure(figsize=(9,5))
city_sales.sort_values().plot(kind="barh")
plt.title("Sales by City")
plt.xlabel("Sales")
plt.tight_layout()
plt.savefig("../charts/city_sales.png", dpi=150)
plt.close()

print("\nCharts saved in ../charts/")
