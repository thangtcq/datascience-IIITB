from mrjob.job import MRJob

class MRTopSellingLiquorCategories(MRJob):

    # Mapper: emit (item_description, bottles_sold)
    def mapper(self, _, line):
        fields = line.split(',')
        try:
            item = fields[4]  # Item_Description
            bottles = int(fields[5])  # Bottles_Sold
            yield item, bottles
        except:
            pass  # Skip malformed lines

    # Reducer: sum all bottles sold per item
    def reducer(self, item, bottles_list):
        yield item, sum(bottles_list)

if __name__ == '__main__':
    MRTopSellingLiquorCategories.run()
