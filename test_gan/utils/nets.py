import tensorflow as tf
import tensorflow.contrib.layers as tcl


# mlp

class GMlp:
    def __init__(self):
        self.name = "mlp_G"

    def __call__(self, mlp_g, data_seed, n_feature):
        with tf.variable_scope(self.name) as vs:
            n_layer = mlp_g.__len__()

            if n_layer > 0:
                for r_layer in range(n_layer):
                    if r_layer == 0:
                        g = tcl.fully_connected(data_seed, mlp_g[r_layer], activation_fn=None,
                                                weights_initializer=None)
                    else:
                        g = tcl.fully_connected(g, mlp_g[r_layer], activation_fn=None,
                                                weights_initializer=None)
                g = tcl.fully_connected(g, n_feature, activation_fn=None,
                                        weights_initializer=None)
            else:
                g = tcl.fully_connected(data_seed, n_feature, activation_fn=None,
                                        weights_initializer=None)

        return g

    @property
    def vars(self):
        return tf.get_collection(tf.GraphKeys.TRAINABLE_VARIABLES, scope=self.name)


class DMlp:
    def __init__(self):
        self.name = "mlp_D"

    def __call__(self, mlp_d_shared, mlp_d_d, mlp_d_q, data_sample, n_class, reuse=False):
        with tf.variable_scope(self.name) as scope:
            if reuse:
                scope.reuse_variables()

            n_layer_shared = mlp_d_shared.__len__()
            n_layer_d = mlp_d_d.__len__()
            n_layer_q = mlp_d_q.__len__()

            if n_layer_shared > 0:
                for r_layer in range(n_layer_shared):
                    if r_layer == 0:
                        shared = tcl.fully_connected(data_sample, mlp_d_shared[r_layer], activation_fn=tf.nn.relu,
                                                     weights_initializer=None)
                    else:
                        shared = tcl.fully_connected(shared, mlp_d_shared[r_layer], activation_fn=tf.nn.relu,
                                                     weights_initializer=None)

                if n_layer_d > 0:
                    for r_layer in range(n_layer_d):
                        if r_layer == 0:
                            d = tcl.fully_connected(shared, mlp_d_d[r_layer], activation_fn=tf.nn.relu,
                                                    weights_initializer=None)
                        else:
                            d = tcl.fully_connected(d, mlp_d_d[r_layer], activation_fn=tf.nn.relu,
                                                    weights_initializer=None)
                    d = tcl.fully_connected(d, n_class, activation_fn=tf.nn.softmax,
                                            weights_initializer=None)
                else:
                    d = tcl.fully_connected(shared, n_class, activation_fn=tf.nn.softmax,
                                            weights_initializer=None)

                if n_layer_q > 0:
                    for r_layer in range(n_layer_q):
                        if r_layer == 0:
                            q = tcl.fully_connected(shared, mlp_d_q[r_layer], activation_fn=tf.nn.relu,
                                                    weights_initializer=None)
                        else:
                            q = tcl.fully_connected(q, mlp_d_q[r_layer], activation_fn=tf.nn.relu,
                                                    weights_initializer=None)
                    q = tcl.fully_connected(q, n_class, activation_fn=tf.nn.softmax,
                                            weights_initializer=None)
                else:
                    q = tcl.fully_connected(shared, n_class, activation_fn=tf.nn.softmax,
                                            weights_initializer=None)

            else:
                for r_layer in range(n_layer_d):
                    if r_layer == 0:
                        d = tcl.fully_connected(data_sample, mlp_d_d[r_layer], activation_fn=tf.nn.relu,
                                                weights_initializer=None)
                    else:
                        d = tcl.fully_connected(d, mlp_d_d[r_layer], activation_fn=tf.nn.relu,
                                                weights_initializer=None)
                    d = tcl.fully_connected(d, n_class, activation_fn=tf.nn.softmax,
                                            weights_initializer=None)
                else:
                    d = tcl.fully_connected(data_sample, n_class, activation_fn=tf.nn.softmax,
                                            weights_initializer=None)

                if n_layer_q > 0:
                    for r_layer in range(n_layer_q):
                        if r_layer == 0:
                            q = tcl.fully_connected(data_sample, mlp_d_q[r_layer], activation_fn=tf.nn.relu,
                                                    weights_initializer=None)
                        else:
                            q = tcl.fully_connected(q, mlp_d_q[r_layer], activation_fn=tf.nn.relu,
                                                    weights_initializer=None)
                    q = tcl.fully_connected(q, n_class, activation_fn=tf.nn.softmax,
                                            weights_initializer=None)
                else:
                    q = tcl.fully_connected(data_sample, n_class, activation_fn=tf.nn.softmax,
                                            weights_initializer=None)

        return d, q

    @property
    def vars(self):
        return tf.get_collection(tf.GraphKeys.TRAINABLE_VARIABLES, scope=self.name)


class QMlp:
    def __init__(self):
        self.name = "mlp_Q"

    def __call__(self, mlp_q, data_sample, n_class, reuse=False):
        with tf.variable_scope(self.name) as scope:
            if reuse:
                scope.reuse_variables()

            n_layer = mlp_q.__len__()

            if n_layer > 0:
                for r_layer in range(n_layer):
                    if r_layer == 0:
                        q = tcl.fully_connected(data_sample, mlp_q[r_layer], activation_fn=tf.nn.relu,
                                                weights_initializer=None)
                    else:
                        q = tcl.fully_connected(q, mlp_q[r_layer], activation_fn=tf.nn.relu,
                                                weights_initializer=None)
                q = tcl.fully_connected(q, n_class, activation_fn=tf.nn.softmax,
                                        weights_initializer=None)
            else:
                q = tcl.fully_connected(data_sample, n_class, activation_fn=tf.nn.softmax,
                                        weights_initializer=None)

        return q

    @property
    def vars(self):
        return tf.get_collection(tf.GraphKeys.TRAINABLE_VARIABLES, scope=self.name)
