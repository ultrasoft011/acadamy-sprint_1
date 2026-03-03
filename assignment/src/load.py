from typing import Dict
from pandas import DataFrame
from sqlalchemy.engine.base import Engine

def load(data_frames: Dict[str, DataFrame], database: Engine):
    """Load the dataframes into the sqlite database.

    Args:
        data_frames (Dict[str, DataFrame]): A dictionary with keys as the table names
        and values as the dataframes.
    """
    # TODO: Implement this function. For each dataframe in the dictionary, you must
    # use pandas.Dataframe.to_sql() to load the dataframe into the database as a
    # table.
    
    for table_name, df in data_frames.items():
        # Usamos to_sql para enviar el dataframe a la base de datos.
        # index=False evita que se cree una columna extra para los índices de pandas.
        # if_exists='replace' es común en ejercicios para poder ejecutarlo varias veces.
        df.to_sql(name=table_name, con=database, index=False, if_exists='replace')

    # Quitamos el raise NotImplementedError porque ya está hecho.