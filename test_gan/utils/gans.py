import math
import os
import scipy.io
import numpy as np
import tensorflow as tf


def label_generation(n1, n2, r_temp):
    label = np.zeros([n1, n2])
    for r in range(n1):
        if r_temp[r] < 0:
            r_temp[r] = np.random.randint(n2)
        label[r, r_temp[r]] = 1
    return label


def seed_generation(n1, n2):
    return np.random.uniform(-1., 1., size=[n1, n2])


class GAN:
    def __init__(self, gan_type, net_g, net_d, net_q, mlp_g, mlp_d_shared, mlp_d_d, mlp_d_q, mlp_q, data):
        self.gan_type = gan_type
        self.generator = net_g
        self.discriminator = net_d
        self.classifier = net_q

        self.mlp_generator = mlp_g
        self.mlp_discriminator_shared = mlp_d_shared
        self.mlp_discriminator_d = mlp_d_d
        self.mlp_discriminator_q = mlp_d_q
        self.mlp_classifier = mlp_q

        self.data = data

        self.feature = tf.placeholder(tf.float32, shape=[None, self.data.n_feature])
        self.label = tf.placeholder(tf.float32, shape=[None, self.data.n_class])
        self.seed = tf.placeholder(tf.float32, shape=[None, self.data.n_seed])

        if self.gan_type[0] == 'cgan':
            # nets
            self.data_g = self.generator(self.mlp_generator, self.seed, self.data.n_feature)

            self.data_d_real, _ = self.discriminator(self.mlp_discriminator_shared,
                                                     self.mlp_discriminator_d,
                                                     self.mlp_discriminator_q,
                                                     self.feature,
                                                     self.data.n_class)
            self.data_d_fake, _ = self.discriminator(self.mlp_discriminator_shared,
                                                     self.mlp_discriminator_d,
                                                     self.mlp_discriminator_q,
                                                     self.data_g,
                                                     self.data.n_class,
                                                     reuse=True)

            # loss
            loss_g_temp = tf.nn.sigmoid_cross_entropy_with_logits(
                logits=self.data_d_fake, labels=self.label)

            loss_d_temp_real = tf.nn.sigmoid_cross_entropy_with_logits(
                logits=self.data_d_real, labels=self.label)
            loss_d_temp_fake = tf.nn.sigmoid_cross_entropy_with_logits(
                logits=self.data_d_fake, labels=tf.zeros_like(self.data_d_fake))

            self.loss_g = tf.reduce_mean(loss_g_temp)
            self.loss_d = tf.reduce_mean(loss_d_temp_real) + tf.reduce_mean(loss_d_temp_fake)

            # solver
            if self.gan_type[3] != 0:
                self.solver_g = tf.train.RMSPropOptimizer(
                    learning_rate=self.gan_type[3]).minimize(self.loss_g, var_list=self.generator.vars)
                self.solver_d = tf.train.RMSPropOptimizer(
                    learning_rate=self.gan_type[3]).minimize(self.loss_d, var_list=self.discriminator.vars)
            else:
                self.solver_g = tf.train.AdamOptimizer().minimize(self.loss_g, var_list=self.generator.vars)
                self.solver_d = tf.train.AdamOptimizer().minimize(self.loss_d, var_list=self.discriminator.vars)
        elif self.gan_type[0] == 'wgan':
            # nets
            self.data_g = self.generator(self.mlp_generator, self.seed, self.data.n_feature)

            self.data_d_real, _ = self.discriminator(self.mlp_discriminator_shared,
                                                     self.mlp_discriminator_d,
                                                     self.mlp_discriminator_q,
                                                     self.feature,
                                                     self.data.n_class)
            self.data_d_fake, _ = self.discriminator(self.mlp_discriminator_shared,
                                                     self.mlp_discriminator_d,
                                                     self.mlp_discriminator_q,
                                                     self.data_g,
                                                     self.data.n_class,
                                                     reuse=True)

            # loss
            self.loss_g = - tf.reduce_mean(self.data_d_fake)
            self.loss_d = - tf.reduce_mean(self.data_d_real) + tf.reduce_mean(self.data_d_fake)

            # solver
            if self.gan_type[3] != 0:
                self.solver_g = tf.train.RMSPropOptimizer(
                    learning_rate=self.gan_type[3]).minimize(self.loss_g, var_list=self.generator.vars)
                self.solver_d = tf.train.RMSPropOptimizer(
                    learning_rate=self.gan_type[3]).minimize(self.loss_d, var_list=self.discriminator.vars)
            else:
                self.solver_g = tf.train.AdamOptimizer().minimize(self.loss_g, var_list=self.generator.vars)
                self.solver_d = tf.train.AdamOptimizer().minimize(self.loss_d, var_list=self.discriminator.vars)

            # clip
            self.clip_d = [var.assign(tf.clip_by_value(var, self.gan_type[4][0], self.gan_type[4][1])) for var in self.discriminator.vars]
        elif self.gan_type[0] == 'infogan_shared_on':
            # nets
            self.data_g = self.generator(self.mlp_generator, self.seed, self.data.n_feature)

            self.data_d_real, _ = self.discriminator(self.mlp_discriminator_shared,
                                                     self.mlp_discriminator_d,
                                                     self.mlp_discriminator_q,
                                                     self.feature,
                                                     self.data.n_class)
            self.data_d_fake, self.data_q_fake = self.discriminator(self.mlp_discriminator_shared,
                                                                    self.mlp_discriminator_d,
                                                                    self.mlp_discriminator_q,
                                                                    self.data_g,
                                                                    self.data.n_class,
                                                                    reuse=True)

            # loss
            loss_g_temp = tf.nn.sigmoid_cross_entropy_with_logits(
                logits=self.data_d_fake, labels=self.label)

            loss_d_temp_real = tf.nn.sigmoid_cross_entropy_with_logits(
                logits=self.data_d_real, labels=self.label)
            loss_d_temp_fake = tf.nn.sigmoid_cross_entropy_with_logits(
                logits=self.data_d_fake, labels=tf.zeros_like(self.data_d_fake))

            loss_q_temp = tf.nn.sigmoid_cross_entropy_with_logits(
                logits=self.data_q_fake, labels=self.label)

            self.loss_g = tf.reduce_mean(loss_g_temp)
            self.loss_d = tf.reduce_mean(loss_d_temp_real) + tf.reduce_mean(loss_d_temp_fake)
            self.loss_q = tf.reduce_mean(loss_q_temp)

            # solver
            if self.gan_type[3] != 0:
                self.solver_g = tf.train.RMSPropOptimizer(
                    learning_rate=self.gan_type[3]).minimize(self.loss_g, var_list=self.generator.vars)
                self.solver_d = tf.train.RMSPropOptimizer(
                    learning_rate=self.gan_type[3]).minimize(self.loss_d, var_list=self.discriminator.vars)
                self.solver_q = tf.train.RMSPropOptimizer(
                    learning_rate=self.gan_type[3]).minimize(self.loss_q,
                                                             var_list=self.generator.vars + self.discriminator.vars)
            else:
                self.solver_g = tf.train.AdamOptimizer().minimize(self.loss_g, var_list=self.generator.vars)
                self.solver_d = tf.train.AdamOptimizer().minimize(self.loss_d, var_list=self.discriminator.vars)
                self.solver_q = tf.train.AdamOptimizer().minimize(self.loss_q,
                                                                  var_list=self.generator.vars + self.discriminator.vars)
        elif self.gan_type[0] == 'infogan_shared_off':
            # nets
            self.data_g = self.generator(self.mlp_generator, self.seed, self.data.n_feature)

            self.data_d_real, _ = self.discriminator(self.mlp_discriminator_shared,
                                                     self.mlp_discriminator_d,
                                                     self.mlp_discriminator_q,
                                                     self.feature,
                                                     self.data.n_class)
            self.data_d_fake, _ = self.discriminator(self.mlp_discriminator_shared,
                                                     self.mlp_discriminator_d,
                                                     self.mlp_discriminator_q,
                                                     self.data_g,
                                                     self.data.n_class,
                                                     reuse=True)
            self.data_q_fake = self.classifier(self.mlp_classifier,
                                               self.data_g,
                                               self.data.n_class)

            # loss
            loss_g_temp = tf.nn.sigmoid_cross_entropy_with_logits(
                logits=self.data_d_fake, labels=self.label)

            loss_d_temp_real = tf.nn.sigmoid_cross_entropy_with_logits(
                logits=self.data_d_real, labels=self.label)
            loss_d_temp_fake = tf.nn.sigmoid_cross_entropy_with_logits(
                logits=self.data_d_fake, labels=tf.zeros_like(self.data_d_fake))

            loss_q_temp = tf.nn.sigmoid_cross_entropy_with_logits(
                logits=self.data_q_fake, labels=self.label)

            self.loss_g = tf.reduce_mean(loss_g_temp)
            self.loss_d = tf.reduce_mean(loss_d_temp_real) + tf.reduce_mean(loss_d_temp_fake)
            self.loss_q = tf.reduce_mean(loss_q_temp)

            # solver
            if self.gan_type[3] != 0:
                self.solver_g = tf.train.RMSPropOptimizer(
                    learning_rate=self.gan_type[3]).minimize(self.loss_g, var_list=self.generator.vars)
                self.solver_d = tf.train.RMSPropOptimizer(
                    learning_rate=self.gan_type[3]).minimize(self.loss_d, var_list=self.discriminator.vars)
                self.solver_q = tf.train.RMSPropOptimizer(
                    learning_rate=self.gan_type[3]).minimize(self.loss_q,
                                                             var_list=self.generator.vars + self.discriminator.vars)
            else:
                self.solver_g = tf.train.AdamOptimizer().minimize(self.loss_g, var_list=self.generator.vars)
                self.solver_d = tf.train.AdamOptimizer().minimize(self.loss_d, var_list=self.discriminator.vars)
                self.solver_q = tf.train.AdamOptimizer().minimize(self.loss_q,
                                                                  var_list=self.generator.vars + self.discriminator.vars)

        print('<====================>')
        print('G net:')
        for var in self.generator.vars:
            print(var.name)
        print('')

        print('<====================>')
        print('D net:')
        for var in self.discriminator.vars:
            print(var.name)
        print('')

        print('<====================>')
        print('Q net:')
        for var in self.classifier.vars:
            print(var.name)
        print('')

        self.saver = tf.train.Saver(max_to_keep=1)
        gpu_options = tf.GPUOptions(allow_growth=True)
        self.sess = tf.Session(config=tf.ConfigProto(gpu_options=gpu_options))

    def train(self, dir_model, epoch_all, batch_size):
        dir_model_gan = os.path.join(dir_model, self.gan_type[0] + '(' + str(self.gan_type[1]) + ')-' + str(epoch_all))
        if not os.path.exists(dir_model_gan):
            os.makedirs(dir_model_gan)

            loss = np.zeros((epoch_all, 3), dtype=float)

            self.sess.run(tf.global_variables_initializer())
            training_steps = math.ceil(self.data.n_sample / batch_size)
            for epoch in range(epoch_all):
                for step in range(training_steps):
                    feature_sample, r_class = self.data(batch_size, step * batch_size)

                    label_sample = label_generation(batch_size, self.data.n_class, r_class)
                    seed_sample = seed_generation(batch_size, self.data.n_seed)

                    if self.gan_type[0] == 'cgan':
                        # update D
                        for r in range(self.gan_type[2][0]):
                            self.sess.run(
                                self.solver_d,
                                feed_dict={self.feature: feature_sample,
                                           self.label: label_sample,
                                           self.seed: seed_sample})

                        # update G
                        for r in range(self.gan_type[2][1]):
                            self.sess.run(
                                self.solver_g,
                                feed_dict={self.label: label_sample,
                                           self.seed: seed_sample})
                    elif self.gan_type[0] == 'wgan':
                        # update D
                        for r in range(self.gan_type[2][0]):
                            self.sess.run(self.clip_d)
                            self.sess.run(
                                self.solver_d,
                                feed_dict={self.feature: feature_sample,
                                           self.seed: seed_sample})

                        # update G
                        for r in range(self.gan_type[2][1]):
                            self.sess.run(
                                self.solver_g,
                                feed_dict={self.seed: seed_sample})
                    elif self.gan_type[0] == 'infogan_shared_on' or 'infogan_shared_off':
                        # update D
                        for r in range(self.gan_type[2][0]):
                            self.sess.run(
                                self.solver_d,
                                feed_dict={self.feature: feature_sample,
                                           self.label: label_sample,
                                           self.seed: seed_sample})

                        # update G
                        for r in range(self.gan_type[2][1]):
                            self.sess.run(
                                self.solver_g,
                                feed_dict={self.label: label_sample,
                                           self.seed: seed_sample})
                        # update Q
                        for r in range(self.gan_type[2][2]):
                            self.sess.run(
                                self.solver_q,
                                feed_dict={self.label: label_sample,
                                           self.seed: seed_sample})

                # print loss
                feature_sample_all, r_class_all = self.data(self.data.n_sample, 0)
                label_sample_all = label_generation(self.data.n_sample, self.data.n_class, r_class_all)
                seed_sample_all = seed_generation(self.data.n_sample, self.data.n_seed)

                loss_d_curr = 0
                loss_g_curr = 0
                loss_q_curr = 0
                if self.gan_type[0] == 'cgan':
                    loss_d_curr = self.sess.run(
                        self.loss_d,
                        feed_dict={self.feature: feature_sample_all,
                                   self.label: label_sample_all,
                                   self.seed: seed_sample_all})
                    loss_g_curr = self.sess.run(
                        self.loss_g,
                        feed_dict={self.label: label_sample_all,
                                   self.seed: seed_sample_all})
                    print('Iter: {:10};          D loss: {:.10f};          G loss: {:.10f};'.
                          format(epoch, loss_d_curr, loss_g_curr))
                elif self.gan_type[0] == 'wgan':
                    loss_d_curr = self.sess.run(
                        self.loss_d,
                        feed_dict={self.feature: feature_sample_all,
                                   self.seed: seed_sample_all})
                    loss_g_curr = self.sess.run(
                        self.loss_g,
                        feed_dict={self.seed: seed_sample_all})
                    print('Iter: {:10};          D loss: {:.10f};          G loss: {:.10f};'.
                          format(epoch, loss_d_curr, loss_g_curr))
                elif self.gan_type[0] == 'infogan_shared_on' or 'infogan_shared_off':
                    loss_d_curr = self.sess.run(
                        self.loss_d,
                        feed_dict={self.feature: feature_sample_all,
                                   self.label: label_sample_all,
                                   self.seed: seed_sample_all})
                    loss_g_curr, loss_q_curr = self.sess.run(
                        [self.loss_g, self.loss_q],
                        feed_dict={self.label: label_sample_all,
                                   self.seed: seed_sample_all})
                    print('Iter: {:10};          D loss: {:.10f};          G loss: {:.10f};          Q loss: {:.10f};'.
                          format(epoch, loss_d_curr, loss_g_curr, loss_q_curr))

                loss[epoch, 0] = loss_d_curr
                loss[epoch, 1] = loss_g_curr
                loss[epoch, 2] = loss_q_curr

            np.savetxt(os.path.join(dir_model_gan, 'loss.txt'), loss, delimiter=',', fmt='%.18e')
            self.saver.save(self.sess, os.path.join(dir_model_gan, 'GAN'), global_step=epoch_all)
        else:
            print('load exist model!')
            dir_checkpoint = tf.train.get_checkpoint_state(dir_model_gan)
            if dir_checkpoint and dir_checkpoint.model_checkpoint_path:
                self.saver.restore(self.sess, dir_checkpoint.model_checkpoint_path)
            else:
                print('<====================>')
                print('error: ' + dir_model_gan + '!!!!!!!!!!!!!!!!!!!!')
                print('')

    def test(self, dir_feature_seed, file_feature_seed, n_sample_new):
        feature_seed_all = [r_class for r_class in range(n_sample_new.__len__())]

        if self.gan_type[0] == 'cgan':
            for r_class in range(n_sample_new.__len__()):
                if n_sample_new[r_class] == 0 or (self.gan_type[1] != -1 and self.gan_type[1] != r_class):
                    feature_seed = []
                else:
                    label_seed = label_generation(
                        n_sample_new[r_class],
                        self.data.n_class,
                        r_class * np.ones(n_sample_new[r_class], dtype='int'))
                    feature_seed = self.sess.run(self.data_g,
                                                 feed_dict={self.label: label_seed,
                                                            self.seed: seed_generation(n_sample_new[r_class],
                                                                                       self.data.n_seed)})
                feature_seed_all[r_class] = feature_seed
            scipy.io.savemat(dir_feature_seed + '/' + file_feature_seed, {'data': feature_seed_all}, oned_as='column')
        elif self.gan_type[0] == 'wgan':
            for r_class in range(n_sample_new.__len__()):
                if n_sample_new[r_class] == 0 or (self.gan_type[1] != -1 and self.gan_type[1] != r_class):
                    feature_seed = []
                else:
                    feature_seed = self.sess.run(self.data_g,
                                                 feed_dict={self.seed: seed_generation(n_sample_new[r_class],
                                                                                       self.data.n_seed)})
                feature_seed_all[r_class] = feature_seed
            scipy.io.savemat(dir_feature_seed + '/' + file_feature_seed, {'data': feature_seed_all}, oned_as='column')
        elif self.gan_type[0] == 'infogan_shared_on' or 'infogan_shared_off':
            for r_class in range(n_sample_new.__len__()):
                if n_sample_new[r_class] == 0 or (self.gan_type[1] != -1 and self.gan_type[1] != r_class):
                    feature_seed = []
                else:
                    label_seed = label_generation(
                        n_sample_new[r_class],
                        self.data.n_class,
                        r_class * np.ones(n_sample_new[r_class], dtype='int'))
                    feature_seed = self.sess.run(self.data_g,
                                                 feed_dict={self.label: label_seed,
                                                            self.seed: seed_generation(n_sample_new[r_class],
                                                                                       self.data.n_seed)})
                feature_seed_all[r_class] = feature_seed
            scipy.io.savemat(dir_feature_seed + '/' + file_feature_seed, {'data': feature_seed_all}, oned_as='column')
