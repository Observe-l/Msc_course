def load_mnist(path, kind='train'):
    import os
    import gzip
    import numpy as np

    """Load MNIST data from `path`"""
    labels_path = os.path.join(path,
                               '%s-labels-idx1-ubyte.gz'
                               % kind)
    images_path = os.path.join(path,
                               '%s-images-idx3-ubyte.gz'
                               % kind)

    with gzip.open(labels_path, 'rb') as lbpath:
        labels = np.frombuffer(lbpath.read(), dtype=np.uint8,
                               offset=8)

    with gzip.open(images_path, 'rb') as imgpath:
        images = np.frombuffer(imgpath.read(), dtype=np.uint8,
                               offset=16).reshape(len(labels), 784)

    return images, labels

def plot_clusters(X, clusters, centroids):
    import matplotlib.pyplot as plt
    plt.figure()

    for cluster_id, cluster_samples in clusters.items():
        centroid = centroids[cluster_id]
        X_cluster = X[cluster_samples]
        if X_cluster.shape[0] > 0:
            plt.scatter(X_cluster[:,0], X_cluster[:,1], marker='o', color='C{}'.format(cluster_id), s=150)

            for x in X_cluster:
                plt.plot([x[0],centroid[0]], [x[1],centroid[1]], '--', linewidth=0.5, color='k'.format(cluster_id))
            
        plt.scatter(centroid[0], centroid[1], marker='+', color='k', s=250, lw=5)

    plt.tick_params(top=False, bottom=False, left=False, right=False, labelleft=False, labelbottom=False)            
    plt.tight_layout()
    
    plt.show()   