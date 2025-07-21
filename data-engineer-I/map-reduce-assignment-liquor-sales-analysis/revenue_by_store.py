from mrjob.job import MRJob

class MRTotalRevenueByStore(MRJob):

    # Mapper: emit (store_name, sale_dollars)
    def mapper(self, _, line):
        fields = line.split(',')
        try:
            store = fields[1]  # Store_Name
            sales = float(fields[-1])  # Sale_Dollars
            yield store, sales
        except:
            pass  # Skip malformed lines

    # Reducer: sum all sale_dollars per store
    def reducer(self, store, sales_values):
        yield store, round(sum(sales_values), 2)

if __name__ == '__main__':
    MRTotalRevenueByStore.run()