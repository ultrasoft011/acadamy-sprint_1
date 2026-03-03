from typing import Dict

import requests
from pandas import DataFrame, read_csv, read_json, to_datetime


def get_public_holidays(public_holidays_url: str, year: str) -> DataFrame:
    """Get the public holidays for the given year for Brazil.

    Args:
        public_holidays_url (str): url to the public holidays.
        year (str): The year to get the public holidays for.

    Raises:
        SystemExit: If the request fails.

    Returns:
        DataFrame: A dataframe with the public holidays.
    """
    # TODO: Implement this function.
    # You must use the requests library to get the public holidays for the given year.
    # The url is public_holidays_url/{year}/BR.
    # You must delete the columns "types" and "counties" from the dataframe.
    # You must convert the "date" column to datetime.
    # You must raise a SystemExit if the request fails. Research the raise_for_status
    # method from the requests library.

    # 1) Build the API URL in the format required by the instructions
    url = f"{public_holidays_url}/{year}/BR"

    try:
        # 2) Call the API using requests (I add a timeout so it doesn't hang forever)
        response = requests.get(url, timeout=10)

        # 3) If the status code is not 200-ish, this will raise an HTTPError
        response.raise_for_status()

    except requests.RequestException as e:
        # 4) The project asks to raise SystemExit if the request fails
        # I include the original exception message so it's easier to debug
        raise SystemExit(f"Request failed: {e}")

    # 5) The API returns JSON, so we convert it to a pandas DataFrame
    data = response.json()
    df = DataFrame(data)

    # 6) Drop the columns that the instructions say we must remove
    # errors="ignore" means: if the column does not exist, don't crash
    df = df.drop(columns=["types", "counties"], errors="ignore")

    # 7) Convert "date" column to datetime (so we can compare/filter by dates later)
    # errors="coerce" turns bad dates into NaT instead of crashing
    if "date" in df.columns:
        df["date"] = to_datetime(df["date"], errors="coerce")

    return df


def extract(
    csv_folder: str, csv_table_mapping: Dict[str, str], public_holidays_url: str
) -> Dict[str, DataFrame]:
    """Extract the data from the csv files and load them into the dataframes.
    Args:
        csv_folder (str): The path to the csv's folder.
        csv_table_mapping (Dict[str, str]): The mapping of the csv file names to the
        table names.
        public_holidays_url (str): The url to the public holidays.
    Returns:
        Dict[str, DataFrame]: A dictionary with keys as the table names and values as
        the dataframes.
    """
    # Here I read every CSV file and store it in a dictionary.
    # The key is the table name (like "orders") and the value is the DataFrame.
    dataframes = {
        table_name: read_csv(f"{csv_folder}/{csv_file}")
        for csv_file, table_name in csv_table_mapping.items()
    }

    # We also need public holidays data (from the API) for year 2017
    holidays = get_public_holidays(public_holidays_url, "2017")

    # Add it to the dictionary so later modules can load/query it too
    dataframes["public_holidays"] = holidays

    return dataframes