import os
import tensorflow as tf

gan_name = 'cgan'
data_name = '0.4s(0.75)Split1Sub(02)LSTM(3,6)'
r_class = 1
epoch = 64

model_dir = 'ckpt/' + data_name + '/' + gan_name + '(' + str(r_class) + ')-' + str(epoch)
checkpoint_path = os.path.join(model_dir, 'GAN-' + str(epoch))

saver = tf.train.import_meta_graph(checkpoint_path+'.meta', clear_devices=True)
graph = tf.get_default_graph()
with tf.Session(graph=graph) as sess:
    sess.run(tf.global_variables_initializer())
    saver.restore(sess, checkpoint_path)

    tvs = [v for v in tf.trainable_variables()]
    for v in tvs:
        print('')
        print(v.name)

        m_temp = sess.run(v)
        print(m_temp)

    for v in tvs:
        print('')
        print(v.name)

        m_temp_shape = v.shape
        print(m_temp_shape)
