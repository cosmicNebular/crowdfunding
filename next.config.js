const withBundleAnalyzer = require('@next/bundle-analyzer')({
    enabled: process.env.ANALYZE === 'true'
})

module.exports = withBundleAnalyzer({
    basePath: 'front/pages',
    devIndicators: {
        buildActivityPosition: 'bottom-right',
    }
});