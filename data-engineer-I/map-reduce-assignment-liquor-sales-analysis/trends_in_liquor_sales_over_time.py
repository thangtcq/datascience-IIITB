from mrjob.job import MRJob
from datetime import datetime

class MRLiquorSalesTrends(MRJob):

    # Mapper: emit (month_year, sale_dollars)
    def mapper(self, _, line):
        fields = line.split(',')
        try:
            date_str = fields[0]  # Date field
            sales = float(fields[-1])  # Sale_Dollars
            # Parse date and extract month-year
            date_obj = datetime.strptime(date_str, '%m/%d/%Y')
            key = date_obj.strftime('%Y-%m')  # Format: YYYY-MM
            yield key, sales
        except:
            pass  # Skip malformed lines

    # Reducer: sum all sales per month-year
    def reducer(self, key, sales_values):
        yield key, round(sum(sales_values), 2)

if __name__ == '__main__':
    MRLiquorSalesTrends.run()