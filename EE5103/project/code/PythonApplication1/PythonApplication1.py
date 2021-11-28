
import numpy as np
import matplotlib.pyplot as plt

class Filter:
    def __init__(self, filter=None):
        self.filter = filter
        self.filter.predict()

    def get_point(self):
        return self.filter.x[0:2, :].flatten()

    def predict_point(self, measurement):
        self.filter.update(measurement)
        self.filter.predict()
        #print self.filter.x
        return self.get_point()

class KalmanFilter(Filter):
    def __init__(self, sigma):
        """
        Kalman Filter Constructor
        
        Algorithms:
            X: state matrix [[ x ],
                             [ y ],
                             [ x_velocity ],
                             [ y_velocity ],
                             [ x_acceleration ],
                             [ y_acceleration ]]
            << State Transition >>
                x <- x + x_velocity
                y <- y + y_velocity
                x_velocity <- x_velocity + x_acceleration
                y_velocity <- y_velocity + y_acceleration
                x_acceleration <- x_acceleration
                y_acceleration <- y_acceleration
                
        Args:
            sigma (float): measurement uncertainty
        """
        self.x = np.array([[0. for i in xrange(6)]]).reshape(-1, 1)
        self.f = np.array([[1, 0, 1, 0, 0, 0],
                           [0, 1, 0, 1, 0, 0],
                           [0, 0, 1, 0, 1, 0],
                           [0, 0, 0, 1, 0, 1],
                           [0, 0, 0, 0, 1, 0],
                           [0, 0, 0, 0, 0, 1]])
        self.p = np.diag([999. for i in xrange(6)])
        self.h = np.array([[1., 0., 0., 0., 0., 0.],
                           [0., 1., 0., 0., 0., 0.]])
        self.r = np.array([[sigma, 0.],
                           [0., sigma]])
        self.i = np.identity(6)

    def predict(self):
        """
        Prediction Step in Kalman Filter
        
        Algorithms:
            x = f*x
            p = f*p*f^T
        """
        self.x = self.f.dot(self.x)
        self.p = self.f.dot(self.p).dot(self.f.transpose())

    def update(self, measurement):
        """
        Update Step in Kalman Filter.
        
        Algorithms:
            Z = measurement matrix (2x1)
            y = z - h * x (error between sensor measurement and predicted value)
            s = h * p * h^T + r
            k = p * h^T * s^-1 (kalman gain)
            x = x_real = x + k * y
            p = p_real = (I - k * h)*p       
                
        Args:
            measurement (list): [x, y] coordinates
        """

        z = np.array(measurement).reshape(-1, 1)
        y = z - self.h.dot(self.x)
        s = self.h.dot(self.p).dot(self.h.transpose()) + self.r
        k = self.p.dot(self.h.transpose()).dot(np.linalg.inv(s))

        self.x = self.x + k.dot(y)
        self.p = (self.i - k.dot(self.h)).dot(self.p)


class ExtendedKalmanFilter(Filter):
    def __init__(self, sigma):
        self.x = np.array([0.,  #x
                           0.,  #y
                           0.,  # heading
                           0.,  # rotation
                           0.]).reshape(-1, 1) # distance

        self.p = np.diag([999 for i in xrange(5)])
        self.h = np.array([[1., 0., 0., 0., 0.],
                           [0., 1., 0., 0., 0.]])

        self.r = np.diag([sigma, sigma])
    def get_state_transition_matrix(self):
        x, y, h, r, d = self.x
        return np.array([
                [1, 0, -d*np.cos(h) + d*np.cos(r + h), d*np.cos(r + h), -np.sin(h) + np.sin(h + r)],
                [0, 1, -d*np.sin(h) - d*np.sin(r - h), d*np.sin(r - h), np.cos(h) - np.cos(h - r)],
                [0, 0,                                   1,                   1, 0],
                [0, 0,                                   0,                   1, 0],
                [0, 0,           0, 0, 1]])



    def predict(self):
        f = self.get_state_transition_matrix()
        x, y, h, r, d = self.x

        new_x = x - d * np.sin(h) + d * np.sin(h + r)
        new_y = y + d * np.cos(h) - d * np.cos(h - r)
        new_h = h + r
        new_r = r
        new_d = d

        self.x = np.array([new_x, new_y, new_h, new_r, new_d]).reshape(-1, 1)
        self.x += np.array([1e-7 for i in xrange(5)]).reshape(-1, 1)
        self.p = f.dot(self.p).dot(f.transpose())


    def update(self, measurement):
        z = np.array(measurement).reshape(-1, 1)
        y = z - self.h.dot(self.x)

        s = self.h.dot(self.p).dot(self.h.transpose()) + self.r
        k = self.p.dot(self.h.transpose()).dot(np.linalg.inv(s))

        self.x = self.x + k.dot(y)
        self.p = (np.eye(5) - k.dot(self.h)).dot(self.p)


def create_artificial_circle_data(step_size, radius, N):
    # sin graph
    # x = np.arange(-radius, radius*N, step_size)
    # y = np.sin(x) + np.random.randn(len(x)) * 0.1
    # measurements += [[x,y] for x, y in zip(x, y)]

    # circle
    # upper half
    measurements = []
    x = np.arange(-radius, radius, step_size)
    y = np.sqrt(radius**2 - x**2) + np.random.randn(len(x)) # add noise
    measurements += [[x,y] for x, y in zip(x, y)]
    # circle lower half
    x = np.arange(radius, -radius, -step_size)
    y = -np.sqrt(radius**2 - x**2) + np.random.randn(len(x)) # add noise
    measurements += [[x,y] for x, y in zip(x, y)]
    # how many circle
    measurements *= N
    return measurements

def create_function_data(function, range_list, noise=0.0):
    measurements = []
    x = range_list
    y = function(x) + np.random.rand(len(x)) * noise
    measurements += [[x,y] for x, y in zip(x, y)]
    return measurements


def get_dist(pointA, pointB):
    """
    Returns
        float: distance between two points (to calculate distance between real and predicted positions)
    """
    a, b = pointA
    c, d = pointB

    return np.sqrt((a-c)**2 + (b - d)**2)

def action(filter, measurements):
    err_list = []
    result = []

    for i in xrange(len(measurements)):
        m = measurements[i]
        pred = filter.predict_point(m)
        err = get_dist(m, pred)
       # print "error: {}".format(err)
        err_list.append(err)
        result.append(pred)

    return result, err_list

def plot(measurements, result, err_list, radius):
    plt.figure("Kalman Filter Visualization")
    plt.subplot(211)
    plt.scatter([x[0] for x in measurements], [x[1] for x in measurements], c='red', label='Real Position', alpha=0.3, s = 4)
    plt.scatter([x[0] for x in result], [x[1] for x in result], c='blue', label='Predicted Position', alpha=0.3, s = 4, marker='x')
    plt.legend()
    plt.grid('on')
    plt.title("Circular Motion Robot and Kalman Filter Prediction")
    plt.xlabel("X-axis")
    plt.ylabel("Y-axis")
    plt.xlim(-radius, radius)
    plt.ylim(-radius, radius)

    plt.subplot(212)
    plt.plot(err_list, lw=0.1)
    plt.grid('on')
    plt.title("Error MSE(True Position - Predicted Position)")
    plt.xlabel("Iteration")

    plt.tight_layout()
    plt.show()


if __name__ == '__main__':
    EKF = ExtendedKalmanFilter(sigma=0.00001)
    KF = KalmanFilter(sigma=0.01)


    filter = Filter(EKF)
    filter = Filter(KF)
    options = {
        'step_size': 0.1,
        'radius': 400,
        'N': 10,
    }

    measurements = create_artificial_circle_data(**options)
    result, err_list = action(filter, measurements)
    plot(measurements, result, err_list, radius = options['radius']*2)

    # measurements = create_function_data(np.sin, np.arange(-10, 10, 0.001), noise=0.1)
    # result, err_list = action(filter, measurements)
    # plot(measurements, result, err_list, radius = 20) 