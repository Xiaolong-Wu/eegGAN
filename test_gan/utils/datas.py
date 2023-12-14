import math
import numpy as np
import scipy.io


class ReadMat:
    def __init__(self, path_data, n_class, n_seed, r_class):
        self.train_data = scipy.io.loadmat(path_data)['train_data'][:, 0]
        self.train_data = np.array(list(self.train_data), dtype=np.float)
        self.train_data = self.train_data.reshape(self.train_data.shape[0], -1)

        self.train_label = scipy.io.loadmat(path_data)['train_label'][:, 0]
        self.train_label = np.array(list(self.train_label), dtype=np.int)

        if r_class >= 0:
            index = np.where(self.train_label == r_class)

            self.train_data = self.train_data[index]
            self.train_label = self.train_label[index]

        self.n_sample = self.train_data.shape[0]
        self.n_feature = self.train_data.shape[-1]

        self.n_class = n_class
        self.n_seed = n_seed

        print('')
        print('number of samples:')
        print(self.n_sample)
        print('number of features:')
        print(self.n_feature)

    def __call__(self, batch_size, batch_start):
        batch_end = batch_start + batch_size
        if batch_end > self.n_sample:
            batch_end = self.n_sample
        index = np.arange(batch_start, batch_end)

        batch_size_temp = batch_end - batch_start
        n0 = batch_size / batch_size_temp
        n1 = batch_size // batch_size_temp
        n2 = batch_size % batch_size_temp

        if n0 > 1:
            index_all = index
            if n1 > 1:
                for i in range(n1-1):
                    index_all = np.concatenate((index_all, index), axis=0)
            if n2 > 0:
                index_all = np.concatenate((index_all, index[:n2]), axis=0)
            index = index_all

        batch = self.train_data[index]
        batch = batch.reshape(batch_size, -1)
        r_class = self.train_label[index]

        return batch, r_class
