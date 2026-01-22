import pandas as pd
from datetime import datetime
import json
import os

INPUT_EXCEL_FILE = "product-review.xlsx"
OUTPUT_JSON_FILE = "reviews.json"

# Auto-detect engine
engine = "openpyxl" if INPUT_EXCEL_FILE.endswith("xlsx") else "xlrd"

excel = pd.ExcelFile(INPUT_EXCEL_FILE, engine=engine)

all_reviews = []

for sheet_name in excel.sheet_names:
    df = excel.parse(sheet_name)

    for _, row in df.iterrows():
        formatted_date = datetime.strptime(str(row["Date"]), "%d/%m/%Y").strftime(
            "%Y-%m-%d"
        )

        all_reviews.append(
            {
                "sheet": sheet_name,
                "reviewerName": row["Reviewer Name"],
                "review": row["Review"],
                "stars": int(row["Rating"]),
                "reviewDate": formatted_date,
            }
        )

with open(OUTPUT_JSON_FILE, "w", encoding="utf-8") as f:
    json.dump(all_reviews, f, indent=2, ensure_ascii=False)

print("All sheets successfully converted into JSON.")


# import pandas as pd
# from datetime import datetime
# import json

# # ---- CONFIG ----
# INPUT_EXCEL_FILE = "product-review.xlsx"
# OUTPUT_JSON_FILE = "reviews.json"

# # ---- LOAD EXCEL ----
# df = pd.read_excel(INPUT_EXCEL_FILE, engine="openpyxl")

# # ---- TRANSFORM DATA ----
# json_data = []

# for _, row in df.iterrows():
#     formatted_date = datetime.strptime(str(row["Date"]), "%d/%m/%Y").strftime(
#         "%Y-%m-%d"
#     )

#     json_data.append(
#         {
#             "reviewerName": row["Name"],
#             "review": row["Review"],
#             "stars": int(row["Rating"]),
#             "reviewDate": formatted_date,
#         }
#     )

# # ---- WRITE JSON ----
# with open(OUTPUT_JSON_FILE, "w", encoding="utf-8") as f:
#     json.dump(json_data, f, indent=2, ensure_ascii=False)

# print("Excel successfully converted to JSON.")
