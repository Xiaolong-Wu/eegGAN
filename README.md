# eegGAN

eegGAN: GANs used to generate EEG features, and classifiers used to identify EEG features


Some preliminary work requires the use of MATLAB code (folder test_matlab), combined with our previous work, to extract features from EEG signals:

https://github.com/Xiaolong-Wu/eegGA


Finally, the Python code generates EEG features (folder test_gan) and distinguishes these features (folder test_trainSet_...) for the goals like building brain-computer interface models of motor imagery.
The GANs in this code is referenced from OpenAI's work:

https://github.com/Xiaolong-Wu/GAN

And Transformer classifier is referenced from:

https://github.com/Xiaolong-Wu/attention-is-all-you-need-pytorch
