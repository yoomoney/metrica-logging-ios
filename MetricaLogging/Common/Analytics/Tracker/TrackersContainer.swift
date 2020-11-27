/* The MIT License
 *
 * Copyright © 2020 NBCO YooMoney LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

final class TrackersContainer: Tracker {
    private let appMetricaTracker: AppMetricaTracker
    private let fabricTracker: FabricTracker
    private let amplitudeTracker: AmplitudeTracker
    private let systemLogTracker: SystemLogTracker
    
    init(appMetricaTracker: AppMetricaTracker,
         fabricTracker: FabricTracker,
         amplitudeTracker: AmplitudeTracker,
         systemLogTracker: SystemLogTracker
    ) {
        self.appMetricaTracker = appMetricaTracker
        self.fabricTracker = fabricTracker
        self.amplitudeTracker = amplitudeTracker
        self.systemLogTracker = systemLogTracker
    }
    
    func track(event: Event) {
        appMetricaTracker.track(event: event)
        fabricTracker.track(event: event)
        systemLogTracker.track(event: event)
        amplitudeTracker.track(event: event)
    }
}

