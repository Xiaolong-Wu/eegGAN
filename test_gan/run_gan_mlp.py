from utils.datas import *
from utils.gans import *
from utils.nets import *

if __name__ == '__main__':

    n_class = 2
    n_seed = 15
    n_data_new = [0, 4500]

    # GAN type
    # data label
    # D & G (Q) learning times
    # learning rate (a small number, such as 1e-4)
    # clip range [min, max], such as [-0.01, 0.01]

    gan_type = ['cgan', 1, [1, 5], 0]
    # gan_type = ['wgan', 1, [1, 1], 0, [-0.1, 0.1]]
    # gan_type = ['infogan_shared_on', 1, [1, 5, 1], 0]
    # gan_type = ['infogan_shared_off', 1, [1, 5, 5], 0]

    mlp_generator = [16, 64, 256]
    mlp_discriminator_shared = [256, 64]
    mlp_discriminator_d = [16]
    mlp_discriminator_q = [16]
    mlp_classifier = [256, 64, 16]

    train_epoch = 64
    train_batch = 64

    # all data
    run_tOlr = ['0.4s(0.75)']
    run_m = [
        ''
    ]
    run_groupSet = [
        'Split1',
        'Split2',
        'Split3'
    ]
    run_subject = [
        '02',
        '03',
        '04',
        '05',
        '06',
        '07',
        '08',
        '12'
    ]
    run_LSTM = ['LSTM(3,6)']

    allData = []
    for r1 in range(len(run_tOlr)):
        for r2 in range(len(run_m)):
            for r3 in range(len(run_groupSet)):
                for r4 in range(len(run_subject)):
                    for r5 in range(len(run_LSTM)):
                        allData.append(
                            run_tOlr[r1] + run_m[r2] + run_groupSet[r3] + 'Sub(' + run_subject[r4] + ')' + run_LSTM[r5])

    for iData in range(len(allData)):
        data_name = allData[iData]

        # load train data
        path_data = 'data/' + data_name + '.mat'
        # save GAN model
        path_model = 'ckpt/' + data_name + '/'
        # save generated sample
        path_data_new = 'data/' + gan_type[0]
        name_data_new = data_name + '.mat'

        if not os.path.exists(path_model):
            os.makedirs(path_model)
        if not os.path.exists(path_data_new):
            os.makedirs(path_data_new)

        results = os.path.join(path_data_new, name_data_new)
        if not os.path.isfile(results):
            os.environ['CUDA_VISIBLE_DEVICES'] = '0'

            # param
            generator = GMlp()
            discriminator = DMlp()
            classifier = QMlp()

            r_class = gan_type[1]
            train_data = ReadMat(path_data, n_class, n_seed, r_class)

            # run
            gan = GAN(
                gan_type,
                generator,
                discriminator,
                classifier,
                mlp_generator,
                mlp_discriminator_shared,
                mlp_discriminator_d,
                mlp_discriminator_q,
                mlp_classifier,
                train_data)

            gan.train(path_model, train_epoch, train_batch)
            gan.test(path_data_new, name_data_new, n_data_new)
