from mrjob.job import MRJob

class MRCountyLevelSalesAnalysis(MRJob):

    # Mapper: emit (county, (bottles_sold, sale_dollars))
    def mapper(self, _, line):
        fields = line.split(',')
        try:
            county = fields[3]  # County
            bottles = int(fields[5])  # Bottles_Sold
            sales = float(fields[-1])  # Sale_Dollars
            yield county, (bottles, sales)
        except:
            pass  # Skip malformed lines

    # Reducer: sum bottles and sales per county
    def reducer(self, county, values):
        total_bottles = 0
        total_sales = 0.0
        for bottles, sales in values:
            total_bottles += bottles
            total_sales += sales
        yield county, {
            'total_bottles': total_bottles,
            'total_sales': round(total_sales, 2)
        }

if __name__ == '__main__':
    MRCountyLevelSalesAnalysis.run()
