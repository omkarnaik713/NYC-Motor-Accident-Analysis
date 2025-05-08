import pandas as pd
import asyncio
from geopy.adapters import AioHTTPAdapter
from geopy.geocoders import Nominatim

# Load dataset
dataset = pd.read_csv('/Users/omkarnaik/Downloads/nyc_crash_bef_without_borough.csv')

# Clean up LOCATION column
dataset['LOCATION'] = dataset['LOCATION'].str.replace('(', '', regex=False)
dataset['LOCATION'] = dataset['LOCATION'].str.replace(')', '', regex=False)

# Async function for reverse geocoding
async def reverse_geocode(dataset):
    async with Nominatim(
        user_agent="myApp",
        adapter_factory=AioHTTPAdapter,
    ) as geolocator:
        for i in range(len(dataset)):
            try:
                location = await geolocator.reverse(dataset['LOCATION'].iloc[i], timeout = 10)
                borough = location.raw['address'].get('borough', 'Unknown')
                dataset.at[i, 'BOROUGH'] = borough
                print(f'Successful: {borough}')
            except Exception as e:
                print(f'Error: {e}')

# Run the async function
asyncio.run(reverse_geocode(dataset))

# Print dataset head
print(dataset.head())
dataset.to_csv('nyc_crash_with_borough_2.csv')
