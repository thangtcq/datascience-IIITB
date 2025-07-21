from mrjob.job import MRJob

class MRStorePerformanceAnalysis(MRJob):

    # Mapper: emit (store_name, (bottles_sold, sale_dollars, 1 transaction))
    def mapper(self, _, line):
        fields = line.split(',')
        try:
            store = fields[1]  # Store_Name
            bottles = int(fields[5])  # Bottles_Sold
            sales = float(fields[-1])  # Sale_Dollars
            yield store, (bottles, sales, 1)
        except:
            pass  # Skip malformed lines

    # Reducer: aggregate bottles, sales, and transaction count
    def reducer(self, store, values):
        total_bottles = 0
        total_sales = 0.0
        total_transactions = 0
        for bottles, sales, count in values:
            total_bottles += bottles
            total_sales += sales
            total_transactions += count
        avg_sales_per_txn = total_sales / total_transactions if total_transactions else 0
        yield store, {
            'total_bottles': total_bottles,
            'total_sales': round(total_sales, 2),
            'transactions': total_transactions,
            'avg_sales_per_transaction': round(avg_sales_per_txn, 2)
        }

if __name__ == '__main__':
    MRStorePerformanceAnalysis.run()
