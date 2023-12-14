import os
import json
import numpy as np
from core.process_data import DataLoad
from core.process_model import Model

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

allEpochs = [
    256
]

configs = json.load(open('config.json', 'r'))

modelPathAll = configs['model']['save_dir']
if not os.path.exists(modelPathAll):
    os.makedirs(modelPathAll)

resultsPathAll = os.path.join(configs['model']['save_dir'], 'results_2023')
if not os.path.exists(resultsPathAll):
    os.makedirs(resultsPathAll)

for iData in range(len(allData)):

    tempData = allData[iData]

    resultsName = tempData + ".txt"
    resultsPath = os.path.join(resultsPathAll, resultsName)
    if not os.path.isfile(resultsPath):

        modelPathTempData = os.path.join(modelPathAll, tempData)
        if not os.path.exists(modelPathTempData):
            os.makedirs(modelPathTempData)

        nEpochs = allEpochs.__len__()
        results = np.zeros((nEpochs, 1))
        for iEpochs in range(nEpochs):

            tempEpochs = allEpochs[iEpochs]
            configs = json.load(open('config.json', 'r'))

            if configs['data']['filename'] == "":
                configs['data']['filename'] = tempData + ".mat"

            if configs['training']['epochs'] == "":
                configs['training']['epochs'] = tempEpochs

            data = DataLoad(
                os.path.join('data', configs['data']['filename']),
                configs['data']['n_class']
            )

            model = Model()
            modelName = configs['model']['name'] + "-epochs(" + str(configs['training']['epochs']) + ").h5"
            modelPath = os.path.join(modelPathTempData, modelName)
            if os.path.isfile(modelPath):
                model.load_model(modelPath)
            else:
                data.data_show()
                print(' ')

                train_data = data.train_data
                train_label = data.train_label

                input_timesteps = train_data.shape[1]
                input_dim = train_data.shape[2]

                n_class_temp = train_label.shape[1]

                model.build_model(configs, input_timesteps, input_dim, n_class_temp)

                model.train_model(
                    model_name=configs['model']['name'],
                    train_data=train_data,
                    train_label=train_label,
                    epochs=configs['training']['epochs'],
                    batch_size=configs['training']['batch_size'],
                    save_dir=modelPathTempData
                )

            test_data = data.test_data
            test_label = data.test_label
            predictions = model.test_model(test_data, test_label)

            print(test_label)
            print(' ')
            print(predictions)
            print(' ')

            results = np.hstack((test_label, predictions))

        np.savetxt(resultsPath, results, delimiter=',')
    else:
        results = np.loadtxt(resultsPath, delimiter=',')

    print(results)
